Feature:
  As an user
  I want to be able to edit expenses
  To correct mistakes in adding an expense

Background:
  Given the following users exist:
    | email            | password  | role      |
    | albert@gmail.com | albertein | regular   |
    | msnow@cia.com    | marksnow  | admin     |
  When "msnow@cia.com" signs in with "marksnow"
  Then I follow "Add New Expense"
  And I fill in "expense_name" with "Halo 6"
  And I fill in "expense_amount" with "59.99"
  And I fill in "expense_description" with "Bought halo 6"
  And I press "Submit"

Scenario: edit expense happy path
  When I go to "msnow@cia.com" edit expense page for "1 "
  And I fill in "expense_name" with "Jeans"
  And I fill in "expense_amount" with "20.34"
  And I fill in "expense_description" with "Bought jeans from H&M"
  And I press "Submit"
  Then I should see "Expense edited successfully."

Scenario: edit an expense sad path
  When I go to "msnow@cia.com" edit expense page for "1"
  And I fill in "expense_name" with ""
  And I fill in "expense_amount" with "20.34"
  And I fill in "expense_description" with "Bought jeans from H&M"
  And I press "Submit"
  Then I should see "Expense was not edited successfully. Please try again."

