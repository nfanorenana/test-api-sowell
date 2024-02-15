Feature: Create IssueReport 

    Scenario: Successfully create a new IssueReport
        Given Creating New Company
        Then I create a new user 
        And give a role to that user
        Then log in user with basic auth email and password
        And get token and add to header
        Then I send the correct parameters to the issue_report endpoint
        And a new issue report is successfully registered in the database