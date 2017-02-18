module GakkyBot
  module Twitter
    class Api
      class << self
        def user_timeline(screen_name)
          user_timeline_url = SETTINGS['user_timeline_url']
          headers = {Authorization: "Bearer #{Twitter::Oauth.bearer_token}"} 
          response = HTTParty.get("#{user_timeline_url}?screen_name=#{screen_name}&count=100", headers: headers)
        end
      end
    end
  end
end
