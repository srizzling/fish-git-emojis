function _gc
	# arg1 is the type
	# arg2 is the scope
	# arg3 is the emoji
	# arg4 is the rest of the the message

	set --local msg ""
 	set jiraId (git rev-parse --abbrev-ref HEAD | string match -r '(?i)[A-Z]{2,}-\d+' | tr -d \n | string upper | tr -d \n)

    switch (count $argv)
        case '4'
            set msg "$argv[2]($argv[3]): $argv[1] $argv[4..-1]"
        case '3'
            set msg "$argv[2]: $argv[1] $argv[3..-1]"
        case '2'
            set msg "$argv"
    end
	if test -n "$jiraId"
		set msg "$msg ($jiraId)"
	end
    if test "$argv[1]" = "🚧"
        git commit --no-verify -sm "$msg"
    else
        git commit -esm "$msg"
    end

end
