class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.datetime :date
      t.float :amount
      t.text :description

      t.timestamps null: false
    end
  end
end
