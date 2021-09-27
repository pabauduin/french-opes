namespace :batch do
  desc "Check new videos of Twitch streamers"

  task check_videos: :environment do
  	get_accesstoken
    get_user
  end

  def get_accesstoken
    puts "---"
    puts "start method"
    require 'faraday'
    require 'uri'
    require 'net/http'

    # IDS
    @twitch_client_id = ENV['CLIENT_ID']
    @twitch_client_secret = ENV['CLIENT_SECRET']

    puts "---"
    puts "start getting access token"

    # Getting access token
    access_token = Faraday.post("https://id.twitch.tv/oauth2/token", {:client_id => @twitch_client_id, :client_secret => @twitch_client_secret, :grant_type => 'client_credentials'})

    # urls from twitch
    base_url = "https://id.twitch.tv/oauth2/"
    url_validate = "https://id.twitch.tv/oauth2/validate"

    # Parsing access token
    @twitch_access_token = JSON.parse(access_token.body)["access_token"]


    # Connecting to API
    @connexion = Faraday.new(url: base_url) do |conn|
      conn.request :oauth2, @twitch_access_token, token_type: :bearer
        conn.adapter Faraday.default_adapter
    end

    @connexion.get(url_validate).body
    puts "---"
    puts "access token renewed"
    puts "expires in : #{JSON.parse(access_token.body)["expires_in"]}"
  end

  def get_user
    base_url_helix = "https://api.twitch.tv/helix/"

    connection = Faraday.new(url: base_url_helix) do |conn|
      conn.request :oauth2, @twitch_access_token, token_type: :bearer
      conn.headers = {'Client-ID' => @twitch_client_id}
        conn.adapter Faraday.default_adapter
    end

    streamers = Streamer.all

    streamers.each do |streamer|
      twitch_user = JSON.parse(connection.get("https://api.twitch.tv/helix/users?login=#{streamer.username}").body)
      twitch_user_id = twitch_user["data"].first["id"]
      twitch_user_name = twitch_user["data"].first["display_name"]
      twitch_user_videos_pages = []
      twitch_user_videos_pages << JSON.parse(connection.get("https://api.twitch.tv/helix/videos?user_id=#{twitch_user_id}&type=archive").body)
      
      if streamer.profile_pic == ""
        streamer.profile_pic = twitch_user["data"].first["profile_image_url"]     
        streamer.save
        puts "streamer #{streamer.username} saved for profile picture"
      end
      
      twitch_user_videos_pages.each do |page|
        page["data"].each do |video|
          if !streamer.all_videos_list == "" || !streamer.all_videos_list.include?(video["created_at"]) 
            streamer.all_videos_list << "#{video["title"]}/;/#{video["created_at"]};/;"
            streamer.videos_number = streamer.videos_number + 1
            puts "---"
            puts "all_video_list incremented for #{streamer.username}"
            streamer.save
            puts "streamer #{streamer.username} saved for all_videos_list"
          end
          if video["title"].downcase.include?("#ad") || video["title"].downcase.include?("sponso") && !video["title"].downcase.include?("pas sponso")
            if streamer.videos_list == "" || !streamer.videos_list.include?(video["created_at"]) 
              streamer.opes_number = streamer.opes_number + 1
              streamer.videos_list << "#{video["title"]}/;/#{video["created_at"]};/;"
              puts "---"
              puts "new video added for #{streamer.username} - #{streamer.updated_at}"
              streamer.save
              puts "streamer #{streamer.username} saved for videos_lists (ads)"
            end
          end
        end
      end
    end
    puts "---"
    puts "Cron terminated :"
    puts DateTime.now
    puts "---"
    puts "---"
  end
end