# app/services/youtube_service.rb
module YoutubeService
  extend self

  def fetch_playlist_items(playlist_id)
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = Rails.application.credentials.google[:api_key]

    response = youtube.list_playlist_items(
      'snippet,contentDetails',
      playlist_id: playlist_id,
      max_results: 10
    )

    response.items
  end
end
