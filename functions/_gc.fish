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
			set msg "$clean_argv[2]($clean_argv[3]): $clean_argv[1] $clean_argv[4..-1]"
		case '3'
			set msg "$clean_argv[2]: $clean_argv[1] $clean_argv[3..-1]"
		case '2'
			set msg "$clean_argv"
	end

	if test -n "$jiraId"
		set msg "$msg ($jiraId)"
	end

	# Commit with or without body
	if test -n "$body"
		if test "$clean_argv[1]" = "🚧"
			git commit --no-verify -m "$msg" -m "$body"
		else
			git commit -m "$msg" -m "$body"
		end
	else
		if test "$clean_argv[1]" = "🚧"
			git commit --no-verify -sm "$msg"
		else
			git commit -esm "$msg"
		end
	end

end
