require 'rails_helper'

RSpec.describe "Diaries", type: :request do
  describe "GET /diaries" do
    let(:user) { create(:user) }
    let!(:diary_today) { create(:diary, user: user, start_time: Date.today, feeling: 2) }
    let(:mock_playlist_item) do
      [
        double('playlist_item', snippet: double('snippet', title: '動画タイトル'),
                                content_details: double('content_details', video_id: '動画ID')),
      ]
    end

    before do
      allow_any_instance_of(YoutubeService).to receive(:fetch_playlist_items).and_return(mock_playlist_item)
      sign_in user
    end
    
    describe 'index' do
      before do
        get diaries_path
      end

      it "httpリクエスト" do
        expect(response).to have_http_status(200)
      end

      describe '日記' do
        context "日記がある場合" do
          it "編集ページへのリンクと日記テキストが取得できること" do
            expect(response.body).to include diary_path(diary_today) # 日記がある日へのリンク
            expect(response.body).to include diary_today.text.truncate(5) # 日記のテキストが表示されること
          end
        end
        context "日記がない場合" do
          it "新規ページへのリンクが取得できること" do
            expect(response.body).to include new_diary_path(date: Date.tomorrow) # 日記がない日へのリンク
          end
        end
      end

      describe "動画" do
        it '動画の情報が取得できること' do
          expect(response.body).to include '動画タイトル'
          expect(response.body).to include "今週のあなたにおすすめの音楽"
        end
      end
    end

    describe 'show' do
      before do
        get diary_path(diary_today)
      end

      it "日記情報が取得できること" do
        expect(response.body).to include diary_today.title
        expect(response.body).to include diary_today.text
        expect(response.body).to include diary_today.start_time.day.to_s
        expect(response.body).to include diary_today.feeling.to_s
      end

      it '動画の情報が取得できること' do
        expect(response.body).to include '動画タイトル'
        expect(response.body).to include "今日のあなたにおすすめの音楽"
      end

    end
  end
end
