Feature: user should provide a username during signup
	As a website admin
	In order to view comment record of each user
	I should use a username field associated with each user

	Scenario: Add username field in user signup
    Given I am on the Signup page
    Then I should see "Username"
    
  Scenario: Add user agreement in signup page
    Given I am on the Signup page
    Then I should see "User Agreement"