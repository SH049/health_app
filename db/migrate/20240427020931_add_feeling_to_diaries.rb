class AddFeelingToDiaries < ActiveRecord::Migration[6.1]
  def change
    add_column :diaries, :feeling, :integer
  end
end
