function _gc
	# arg1 is the emoji
	# arg2 is the type
	# arg3 is the scope (optional)
	# arg4 is the rest of the the message
	# -b flag can be used to specify commit body

	set --local msg ""
	set --local body ""
	set --local clean_argv
	set jiraId (git rev-parse --abbrev-ref HEAD | string match -r '(?i)[A-Z]{2,}-\d+' | tr -d \n | string upper | tr -d \n)

	# Parse -b flag and extract body
	set --local i 1
	while test $i -le (count $argv)
		if test "$argv[$i]" = "-b"
			if test $i -lt (count $argv)
				set body $argv[(math $i + 1)]
				set i (math $i + 2)
			else
				echo "Error: -b flag requires a body argument"
				return 1
			end
		else
			set clean_argv $clean_argv $argv[$i]
			set i (math $i + 1)
		end
	end

	# Process remaining arguments for subject
	switch (count $clean_argv)
		case '4'
			# Check if scope is empty string
			if test "$clean_argv[3]" = ""
				echo "Warning: Empty scope provided. You can omit the scope parameter next time."
				set msg "$clean_argv[2]: $clean_argv[1] $clean_argv[4..-1]"
			else
				set msg "$clean_argv[2]($clean_argv[3]): $clean_argv[1] $clean_argv[4..-1]"
			end
		case '3'
			set msg "$clean_argv[2]: $clean_argv[1] $clean_argv[3..-1]"
		case '2'
			set msg "$clean_argv"
	end

	if test -n "$jiraId"
		set msg "$msg ($jiraId)"
	end

	# Check subject line length (conventional commit 50 char rule)
	set --local subject_length (string length "$msg")
	if test $subject_length -gt 50
		# Calculate overhead to help user
		set --local user_subject_length (string length "$clean_argv[-1]")
		set --local overhead (math $subject_length - $user_subject_length)
		set --local max_allowed (math 50 - $overhead)
		echo "Error: Subject line is $subject_length characters (max 50)"
		echo "Including type, scope, emoji, and JIRA ID, your subject can be max $max_allowed characters"
		echo "Current subject: '$clean_argv[-1]' ($user_subject_length chars)"
		return 1
	end

	# Commit with or without body
	if test -n "$body"
		# Create temporary file for commit message with proper formatting
		set temp_file (mktemp)
		printf "%s\n\n" "$msg" > $temp_file
		# Process body to preserve paragraph breaks while wrapping at 75 chars
		printf "%b" "$body" | awk '
		BEGIN { RS = "\n\n" }
		{
			# Preserve bullet points by converting internal newlines to spaces but keeping bullet structure
			gsub(/\n- /, "\n- ")
			gsub(/\n/, " ")
			gsub(/ - /, "\n- ")
			
			# Split by newlines to handle bullet points separately
			split($0, lines, "\n")
			for (j = 1; j <= length(lines); j++) {
				line = lines[j]
				# Wrap each line at 75 characters with word boundaries
				while (length(line) > 75) {
					for (i = 75; i > 0; i--) {
						if (substr(line, i, 1) == " ") {
							print substr(line, 1, i-1)
							line = substr(line, i+1)
							break
						}
					}
					if (i == 0) {
						print substr(line, 1, 75)
						line = substr(line, 76)
					}
				}
				if (length(line) > 0) print line
			}
			if (NR < NF) print ""
		}
		' >> $temp_file
		
		if test "$clean_argv[1]" = "🚧"
			git commit --no-verify -F $temp_file
		else
			git commit -F $temp_file
		end
		
		rm $temp_file
	else
		if test "$clean_argv[1]" = "🚧"
			git commit --no-verify -sm "$msg"
		else
			git commit -esm "$msg"
		end
	end

end
