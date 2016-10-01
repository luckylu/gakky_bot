module GakkyBot
  module Twitter
    class Api
      class << self
        def user_timeline(bearer_token, screen_name)
          user_timeline_url = SETTINGS['user_timeline_url']
          headers = {Authorization: "Bearer #{bearer_token}"}
          response = HTTParty.get("#{user_timeline_url}?screen_name=#{screen_name}", headers: headers)
        end
      end
    end
  end
end
