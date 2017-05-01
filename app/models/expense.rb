class Expense < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true
  validates :description, presence: true

  def self.sum_time_interval_expenses(user_id, time1, time2)
    weeks = Expense.where(user_id: user_id).where(date: (time1..time2)).group_by(&:week)
    weekly_sums = Hash.new
    weeks.each do |week_num, week|
      sum = 0
      week.each do |expense|
        sum += expense.amount
      end  
      weekly_sums[week_num] = sum
    end 
    weekly_sums
  end

  def self.sum_all_expenses(user_id)
    weeks = Expense.where(user_id: user_id).group_by(&:week)
    weekly_sums = Hash.new
    weeks.each do |week_num, week|
      sum = 0
      week.each do |expense|
        sum += expense.amount
      end  
      weekly_sums[week_num] = sum
    end 
    weekly_sums
  end


  def week
    self.date.strftime('%Y-%W')
  end
end
