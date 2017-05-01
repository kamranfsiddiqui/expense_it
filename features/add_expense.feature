Feature:
  As an user
  I want to be able to add expenses
  To track how much I spend

Background:
  Given the following users exist:
    | email            | password  | role      |
    | albert@gmail.com | albertein | regular   |
    | msnow@cia.com    | marksnow  | admin     |

Scenario: add an expense happy path
  When "msnow@cia.com" signs in with "marksnow"
  Then I follow "Add New Expense"
  And I fill in "expense_name" with "Jeans"
  And I fill in "expense_amount" with "20.34"
  And I fill in "expense_description" with "Bought jeans from H&M"
  And I press "Submit"
  Then I should see "New expense added successfully"

Scenario: add an expense sad path
  When "msnow@cia.com" signs in with "marksnow"
  Then I follow "Add New Expense"
  And I fill in "expense_amount" with "20.34"
  And I fill in "expense_description" with "Bought jeans from H&M"
  And I press "Submit"
  Then I should see "Sorry, there was an error in adding the expense. Please try again."

