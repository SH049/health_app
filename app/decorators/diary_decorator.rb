class DiaryDecorator < ApplicationDecorator
  delegate_all

  # def formatted_totals
  #   daily_totals = object.group("DATE(start_time)").where(start_time: 6.days.ago.beginning_of_day..(Time.zone.now.end_of_day)).order("DATE(start_time)").sum(:feeling)
  #   daily_totals.transform_keys { |date| date.strftime("%m/%d") }
  # end

end
