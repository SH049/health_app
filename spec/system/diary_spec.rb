require 'rails_helper'

RSpec.describe "Diaries", type: :system do
  let(:user) { create(:user) }
  let!(:diary) { create(:diary, user: user, start_time: Date.today) }
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
        # let!(:diary) { create(:diary, user: user, start_time: date) } # 非空のdiaryを作成

        it "日付をクリックするとshowページに飛ぶこと" do
          # click_on date.day

          click_link diary.start_time.day.to_s

          expect(page).to have_current_path(diary_path(diary))
          expect(page).to have_content(diary.text)
          expect(page).to have_content(diary.title)

          expect(current_path).to eq(diary_path(diary))
          # binding pry
          # expect(page).to have_link(date.day, href: diary_path(diary))
        end

        it "テキストをクリックするとshowページに飛ぶこと" do
          # click_on date.day
          click_link diary.text

          expect(page).to have_current_path(diary_path(diary))
          expect(page).to have_content(diary.text)
          expect(page).to have_content(diary.title)

          expect(current_path).to eq(diary_path(diary))

          expect(page).to have_content("今日のあなたにおすすめの音楽")
          expect(page).to have_content("動画タイトル")
          # binding pry
          # expect(page).to have_link(date.day, href: diary_path(diary))
        end
      end

      context "日記がない場合" do
        it "新規作成ページに飛ぶこと" do
          expect(user.diaries.where(start_time: Date.tomorrow)).to be_empty
          click_link Date.tomorrow.day.to_s

          expect(page).to have_current_path(new_diary_path(date: Date.tomorrow))
          # expect(page).to have_selector('form#new_diary')
          # expect(page).to have_link(date.day, href: new_diary_path(date: date))
          # click_link date.day
          # expect(current_path).to eq(diary_path(diary))
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
      visit diary_path(diary) # ページにアクセス
    end
    it '日記が表示されること' do
      expect(page).to have_content(diary.text)
    end
    it '編集ボタンを押すと編集ページに飛ぶこと' do
      click_on "Edit"
      expect(current_path).to eq(edit_diary_path(diary))
    end
    it 'backボタンを押すと一覧ページに飛ぶこと' do
      click_on "Back"
      expect(current_path).to eq(diaries_path)
    end
  end
end
