json.extract! diary, :id, :title, :text, :strat_time, :user_id, :created_at, :updated_at
json.url diary_url(diary, format: :json)
