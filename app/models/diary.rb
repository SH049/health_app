class Diary < ApplicationRecord
  belongs_to :user
  validates :text, presence: true
  validates :start_time, uniqueness: {
    scope: :user_id,
    message: "同じ日付の日記は一つしか作れません",
  }
end
