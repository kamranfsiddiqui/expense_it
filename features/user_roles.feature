Feature:
  As an administrator
  I want only other admins to have access to user expenses
  To keep users info private and secure

Background:
  Given the following users exist:
    | email            | password  | role      |
    | albert@gmail.com | albertein | regular   |
    | msnow@cia.com    | marksnow  | admin     |
    #  Given "albert@gmail.com" adds the following expenses:
    #| name | date | amount | description

Scenario: Admins can see link to all users(and their secrets)
  When "msnow@cia.com" signs in with "marksnow"
  And I should see "All Users"
  When I follow "All Users"
  Then I should see "albert@gmail.com"
  And I follow "Logout"

Scenario: Admin cannot CUD another users expenses
  When "msnow@cia.com" signs in with "marksnow"
  And I should see "All Users"
  When I go to the expenses page for "albert@gmail.com"
  Then I should see "albert@gmail.com"
  Then I should not see "Add New Expense"
  Then I should not see "Edit"
  Then I should not see "Details"
  Then I should not see "Delete"
  And I follow "Logout"

Scenario: Regular users cannot CRUD another users expenses
  When "albert@gmail.com" signs in with "albertein"
  And I should not see "All Users"
  When I go to the expenses page for "msnow@cia.com"
  Then I should see "You cannot access this user's expenses"
  And I follow "Logout"
