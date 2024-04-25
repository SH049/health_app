class ChangeStartTimeToDateInDiaries < ActiveRecord::Migration[6.1]
  def change
    change_column :diaries, :start_time, :date
  end
end
