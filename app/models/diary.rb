class Diary < ApplicationRecord
  belongs_to :user
  validates :text, presence: true, length: { maximum: 500 }
  validates :start_time, uniqueness: {
    scope: :user_id,
    message: "同じ日付の日記は一つしか作れません",
  }

  def self.formatted_totals
    daily_totals = group("DATE(start_time)").
      where(start_time: 6.days.ago.beginning_of_day..(Time.zone.now.end_of_day)).
      order("DATE(start_time)").
      sum(:feeling)
    daily_totals.transform_keys { |date| date.strftime("%m/%d") }
  end

  def self.weekly_average
    number_of_days = (Time.zone.now.to_date - 6.days.ago.to_date + 1).to_f
    total_values = group("DATE(start_time)").
      where(start_time: 6.days.ago.beginning_of_day..(Time.zone.now.end_of_day)).
      order("DATE(start_time)").
      sum(:feeling).
      values.
      sum
    total_values / number_of_days
  end
end
