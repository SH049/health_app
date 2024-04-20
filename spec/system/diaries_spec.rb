require 'rails_helper'

RSpec.describe "Diaries", type: :system do
  before do
    visit diaries_path
  end

  it 'newページに飛ぶこと' do
    click_on 'New Diary'
    expect(current_path).to eq new_diary_path
  end
end
