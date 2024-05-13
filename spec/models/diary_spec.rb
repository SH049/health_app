require 'rails_helper'

RSpec.describe Diary, type: :model do
  let!(:user) { create(:user) }
  let!(:diaries) do
    [
      create(:diary, user: user, start_time: 6.days.ago, feeling: 2),
      create(:diary, user: user, start_time: 5.days.ago, feeling: 3),
      create(:diary, user: user, start_time: 4.days.ago, feeling: 1),
      create(:diary, user: user, start_time: 3.days.ago, feeling: 2),
      create(:diary, user: user, start_time: 2.days.ago, feeling: 3),
      create(:diary, user: user, start_time: 1.day.ago, feeling: 1),
      create(:diary, user: user, start_time: Date.today, feeling: 2),
    ]
  end
  describe ".formatted_totals" do
    it "feelingの合計が出力できるか" do
      expected_totals = {
        6.days.ago.strftime("%m/%d") => 2,
        5.days.ago.strftime("%m/%d") => 3,
        4.day.ago.strftime("%m/%d") => 1,
        3.days.ago.strftime("%m/%d") => 2,
        2.days.ago.strftime("%m/%d") => 3,
        1.day.ago.strftime("%m/%d") => 1,
        Date.today.strftime("%m/%d") => 2,
      }
      expect(Diary.formatted_totals).to eq(expected_totals)
    end
  end

  describe ".weekly_average" do
    it "feelingの一週間の平均が出力できるか" do
      # Expected average: (2 + 3 + 1 + 2 + 3 + 1) / 7 = 14 / 7 = 2
      expect(Diary.weekly_average).to eq(2)
    end
  end
end
