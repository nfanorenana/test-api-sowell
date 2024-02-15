Feature: Learning to automate the POST verb
    I, as a QA
    I want to learn how to automate the POST verb
    To be mom's best friend in the company

Scenario: New User
    Given I create new User

Scenario: Get Token Password Credentials
    Given I logged in with email:"nyonjafanorenana@yahoo.com" and password:"Coucoutoi"
    Then I get the token 

Scenario: Successfully sending a new company
    Given that I send the correct parameters to the companies endpoint
    Then a new company is successfully registered in the database
        