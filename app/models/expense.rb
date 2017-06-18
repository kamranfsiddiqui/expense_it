class Expense < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true
  validates :description, presence: true

  def self.sum_time_interval_expenses(user_id, time1, time2, grouping)
    groups = Expense.where(user_id: user_id).where(date: (time1..time2)).group_by(&grouping)
    group_sums = Hash.new
    sum_expenses(groups, group_sums)
  end

  def self.sum_all_expenses(user_id, grouping)
    groups = Expense.where(user_id: user_id).group_by(&grouping)
    group_sums = Hash.new
    sum_expenses(groups, group_sums)
  end

  def self.sum_expenses(groups, group_sums)
    groups.each do |group_num, group|
      sum = 0
      group.each do |expense|
        sum += expense.amount
      end  
      group_sums[group_num] = sum
    end 
    group_sums
  end

  def self.aggregate_avg(user_id, grouping)
    weeks = Expense.where(user_id: user_id).group_by(&grouping)
    sum = 0
    weeks.each do |week_num, week|
      week.each do |expense|
        sum += expense.amount
      end  
    end 
    sum/weeks.length
  end

  def hour
    self.date.strftime('%Y-%j-%H')
  end

  def day
    self.date.strftime('%Y-%j')
  end

  def week
    self.date.strftime('%Y-%W')
  end

  def month
    self.date.strftime('%Y-%m')
  end

  def year
    self.date.strftime('%Y')
  end

  def self.agg_report_str(group_num, grouping)
    nums = group_num.split("-");
    nums = nums.map{|e| e.to_i}
    if grouping == :hour 
        interval_start = Date.ordinal(nums[0], nums[1]).to_time() + nums[2].hour
        interval_end = interval_start.end_of_hour
        "#{interval_start.strftime("%A, %b %d, %Y %I:%M:%S %P")} to #{interval_end.strftime("%I:%M:%S %P")}"
    elsif grouping == :day
        interval_start = Date.ordinal(nums[0], nums[1]).to_time()
        interval_end = interval_start.end_of_day
        "#{interval_start.strftime("%A, %b %d, %Y %I:%M:%S %P")} to #{interval_end.strftime("%A, %b %d, %Y %I:%M:%S %P")}"
    elsif grouping == :week
        "#{Date.commercial(nums[0],nums[1],1).strftime("%A, %b %d, %Y")} to #{Date.commercial(nums[0],nums[1],7).strftime("%A, %b %d, %Y")}"
    elsif grouping == :month
        "#{Date.civil(nums[0],nums[1],1).strftime("%A, %b %d, %Y")} to #{Date.civil(nums[0],nums[1],-1).strftime("%A, %b %d, %Y")}"
    else
        "#{Date.civil(nums[0]).strftime("%A, %b %d, %Y")} to #{Date.civil(nums[0],-1,-1).strftime("%A, %b %d, %Y")}"
    end

  end

end
