class AddIndexToDiariesStartTimeAndUserId < ActiveRecord::Migration[6.1]
  def change
    add_index :diaries, [:start_time, :user_id], unique: true
  end
end
