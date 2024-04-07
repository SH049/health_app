class CreateDiaries < ActiveRecord::Migration[6.1]
  def change
    create_table :diaries do |t|
      t.string :title
      t.text :text
      t.datetime :datetime
      t.integer :user_id

      t.timestamps
    end
  end
end
