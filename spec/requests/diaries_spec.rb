require 'rails_helper'

RSpec.describe "Diaries", type: :request do
  describe "GET /diaries" do
    let(:user) { create(:user) }
    let(:date) { Date.today }
    
    before do
      sign_in user
      get diaries_path # ページにアクセス
    end

    it "indexが効いているかどうか" do
      expect(response).to have_http_status(200)
    end
  end
end
