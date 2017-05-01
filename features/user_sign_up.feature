Feature: User signing up/signing in
  As an adult with expenses
  I want to be able to sign up/sign in
  So I can track my expenses

Background:
  Given I am on the user sign up page
  When I fill in "Email" with "msnow@cia.com"
  When I fill in "Password" with "marksnow"
  When I fill in "Password confirmation" with "marksnow"
  And I press "Sign up"
  And I follow "My Expenses" 
  And I follow "Logout"

Scenario: Sign In
  When I go to the log in page
  When I fill in "Email" with "msnow@cia.com"
  When I fill in "Password" with "marksnow"
  And I press "Log in"
  Then I should see "Signed in successfully"
  And I follow "Logout"

Scenario: Sign in Sad Path
  When I go to the log in page
  And I fill in "Email" with "carson@ucsf.org"
  And I fill in "Password" with "carson"
  And I press "Log in"
  Then I should see "Invalid email or password"
  
Scenario: Log out
  When I go to the log in page
  When I fill in "Email" with "msnow@cia.com"
  When I fill in "Password" with "marksnow"
  And I press "Log in" 
  Then I should see "Logout"
  When I follow "Logout"
  Then I should see "Signed out successfully"

