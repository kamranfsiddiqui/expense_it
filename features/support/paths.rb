# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      user_path

    when /^the user home page$/
      user_path(current_user)
      
    when /^the log in page$/
      new_user_session_path
      
    when /^the user sign up page$/
      new_user_registration_path

    when /^the expenses page for "(.*)"$/
      user_expenses_path(User.find_by(email: $1))

    when /^the new expense page for "(.*)"$/
      new_user_expense_path(User.find_by(email: $1))

    when /^"(.*)" edit expense page for "(.*)"$/
      edit_user_expense_path(User.find_by(email: $1), Expense.find($2))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
