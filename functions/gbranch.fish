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
            for i in (seq $numIssues)
                set issue (parse_issue $issues[$i])
                echo $i": "$issue
            end
            echo "Please choose one to create a branch. Enter the number of the issue:"
            read -l choice
            if test $choice -ge 1 -a $choice -le $numIssues
                set issueKey (echo $issues[$choice] | awk '{print $1}')
                set issueSummary (echo $issues[$choice] | awk '{$1=""; print $0}' | string trim)
                echo "Chosen issue: "$issueKey" - "$issueSummary
                create_branch $issueKey $issueSummary
            else
                echo "Invalid choice."
            end
    end
end
