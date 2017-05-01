require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Given /the following users exist:/ do |users_table|
  users_table.hashes.each do |row|
    User.create(row)
  end
end

Given /"(.*)" adds the following expenses/ do |u, expenses_table|
  user = User.find_by(email: u)
  expenses_table.hashes.each do |name, year, month,day,hr,min, amount, description|
    datetime = Time.zone.local(year.to_i, month,day, hr,min)
    params = {:name => name, :date => datetime, :amount => amount, :description => description}
    user.expenses.create(params)
  end
end

When /"(.*)" signs in with "(.*)"/ do |email, pass|
  step %{I go to the log in page}
  step %{I fill in "Email" with "#{email}"}
  step %{I fill in "Password" with "#{pass}"}
  step %{I press "Log in"}
  step %{I should see "Signed in successfully"}
end


