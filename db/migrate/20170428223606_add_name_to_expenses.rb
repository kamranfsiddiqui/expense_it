class AddNameToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :name, :text
  end
end
