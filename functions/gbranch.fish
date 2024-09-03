function gbranch

    function get_issues
        jira sprint list --current -a(jira me) --plain -s"In Progress" --no-headers --columns key,summary
    end

    function parse_issue -a issue
        set issueKey (echo $issue | awk '{print $1}')
        set issueSummary (echo $issue | awk '{$1=""; print $0}' | string trim)
        echo $issueKey "-" $issueSummary
    end

    function create_branch -a issueKey issueSummary
        set cleanedSummary (echo $issueSummary | tr ' ' '-' | string lower)
        set branchName (string join '-' $issueKey $cleanedSummary)
        set branchName (echo $branchName | string lower)

        if git rev-parse --verify --quiet $branchName
            echo "Branch '$branchName' already exists."
            set confirm (gum confirm "Would you like to create a new branch with suffix '-v2'?")
            if test -z "$confirm" -o "$confirm" = "false"
                echo "Aborting branch creation."
                return
            end
            set branchName $branchName"-v2"
        end

        git checkout -b $branchName
    end

    # Main script
    set issues (get_issues)
    set numIssues (count $issues)

    switch $numIssues
        case 0
            echo "No issues assigned to you in the current sprint."
        case 1
            set issueKey (echo $issues[1] | awk '{print $1}')
            set issueSummary (echo $issues[1] | awk '{$1=""; print $0}' | string trim)
            echo "Chosen issue: "$issueKey" - "$issueSummary
            create_branch $issueKey $issueSummary
        case '*'
            echo "Multiple issues are assigned to you:"
            set options (for i in (seq $numIssues); parse_issue $issues[$i]; end)
            set selectedIssue (echo $options | gum choose)
            set issueKey (echo $selectedIssue | awk '{print $1}')
            set issueSummary (echo $selectedIssue | awk '{$1=""; print $0}' | string trim)
            echo "Chosen issue: "$issueKey" - "$issueSummary
            create_branch $issueKey $issueSummary
    end
end
