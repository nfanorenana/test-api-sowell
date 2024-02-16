Feature: Create IssueReport 

    Scenario: Successfully create a new IssueReport
        Given Creating New Company
        Then I create a new user 
        And give a role to that user
        Then log in user with basic auth email and password
        And I send the correct parameters to the issue_report endpoint