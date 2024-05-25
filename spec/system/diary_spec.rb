require 'rails_helper'

RSpec.describe "Diaries", type: :system do
  let(:user) { create(:user) }
  let!(:diary_today) { create(:diary, user: user, start_time: Date.today, feeling: 2) }
  let(:mock_playlist_item) do
    [
      double('playlist_item', snippet: double('snippet', title: '動画タイトル'),
                              content_details: double('content_details', video_id: '動画ID')),
    ]
  end

  before do
    sign_in user
    allow_any_instance_of(YoutubeService).to receive(:fetch_playlist_items).and_return(mock_playlist_item)
  end

  describe 'index' do
    before do
      visit diaries_path
    end
    describe '日記' do
      context "日記がある場合" do

        it "日付をクリックするとshowページに飛ぶこと" do
          click_link diary_today.start_time.day.to_s

          expect(page).to have_current_path(diary_path(diary_today))
          expect(page).to have_content(diary_today.text)
          expect(page).to have_content(diary_today.title)

          expect(current_path).to eq(diary_path(diary_today))
        end

        it "テキストをクリックするとshowページに飛ぶこと" do
          click_link diary_today.text

          expect(page).to have_current_path(diary_path(diary_today))
          expect(page).to have_content(diary_today.text)
          expect(page).to have_content(diary_today.title)
          expect(page).to have_content(diary_today.start_time.day.to_s)
          expect(page).to have_content(diary_today.feeling.to_s)

          expect(current_path).to eq(diary_path(diary_today))

          expect(page).to have_content("今日のあなたにおすすめの音楽")
          expect(page).to have_content("動画タイトル")

        end
      end

      context "日記がない場合" do
        it "新規作成ページに飛ぶこと" do
          expect(user.diaries.where(start_time: Date.tomorrow)).to be_empty
          click_link Date.tomorrow.day.to_s

          expect(page).to have_current_path(new_diary_path(date: Date.tomorrow))

        end
      end
    end

    describe '動画' do
      it '動画のタイトルが取得できること' do
        expect(page).to have_content("今週のあなたにおすすめの音楽")
        expect(page).to have_content("動画タイトル")
      end

      it '動画のiframeが正しいURLで表示されること' do
        expect(page).to have_css("iframe[src='https://www.youtube.com/embed/動画ID']")
      end
    end
  end

  describe 'show' do
    before do
      visit diary_path(diary_today) # ページにアクセス
    end
    
    it '日記が表示されること' do
      expect(page).to have_content(diary_today.text)
    end
    
    it '編集ボタンを押すと編集ページに飛ぶこと' do
      click_on "編集"
      expect(current_path).to eq(edit_diary_path(diary_today))
      expect(page).to have_content(diary_today.text)
    end
    
    it '一覧に戻るボタンを押すと一覧ページに飛ぶこと' do
      click_on "一覧に戻る"
      expect(current_path).to eq(diaries_path)
    end
  end

  describe 'new' do
    before do
      visit new_diary_path(date: Date.tomorrow)
    end

    it '日記作成に成功すること' do

      fill_in 'タイトル', with: '仮のタイトル'
      fill_in '内容', with: '仮の内容'
      choose 'よかった'

      click_button '送信'

      expect(page).to have_content('仮のタイトル')
      expect(page).to have_content('仮の内容')
    end

    it '日記作成に失敗すること' do
      visit new_diary_path

      fill_in 'タイトル', with: ''
      fill_in '内容', with: ''
      choose 'ふつう'

      click_button '送信'

      expect(page).to have_content('エラーが発生しました')
    end

    it '一覧に戻るボタンを押すと一覧ページに飛ぶこと' do
      click_on "一覧に戻る"
      expect(current_path).to eq(diaries_path)
    end
  end
end
