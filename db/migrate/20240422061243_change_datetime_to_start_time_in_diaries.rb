class ChangeDatetimeToStartTimeInDiaries < ActiveRecord::Migration[6.1]
  def change
    rename_column :diaries, :datetime, :start_time
  end
end
