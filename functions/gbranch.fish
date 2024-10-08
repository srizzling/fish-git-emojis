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
        # Clean the issue summary by replacing spaces and special characters with hyphens
        set cleanedSummary (echo $issueSummary | tr -cs '[:alnum:]' '-' | string lower | string trim)

        # Replace any leading or trailing hyphens separately (if needed)
        set cleanedSummary (echo $cleanedSummary | sed 's/^-*//;s/-*$//')

        # Join the issue key and cleaned summary with a hyphen
        set branchName (string join '-' $issueKey $cleanedSummary)

        # Check if the branch already exists
        if git rev-parse --verify --quiet $branchName
            echo "Branch '$branchName' already exists."
            if gum confirm "Would you like to create a new branch with suffix '-v2'?"
                set branchName $branchName"-v2"
            else
                echo "Aborting branch creation."
                return
            end
        end

        echo "Branch Name: "$branchName
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
            set selectedIssue (gum choose $options)
            set issueKey (echo $selectedIssue | awk '{print $1}')
            set issueSummary (echo $selectedIssue | awk '{$1=""; print $0}' | string trim)
            echo "Chosen issue: "$issueKey" - "$issueSummary
            create_branch $issueKey $issueSummary
    end
end
