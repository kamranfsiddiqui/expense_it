class Expense < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  validates :description, presence: true
end
