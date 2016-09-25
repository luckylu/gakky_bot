module GakkyBot
  module Twitter
    class Oauth
      class << self
        def bearer_token
          token = GakkyBot::Model::Token.first
          return token.token if token
          encoded_secrets, oauth_token_url = setup
          headers = { "Authorization" => "Basic #{encoded_secrets}",  "Content-Type" => "application/x-www-form-urlencoded;charset=UTF-8"}
          response = HTTParty.post(oauth_token_url, body: {grant_type: 'client_credentials'}, headers: headers)
          access_token = JSON.parse(response.body)['access_token']
          GakkyBot::Model::Token.create(token: access_token)
          access_token
        end

        def setup
          secrets = YAML.load_file(File.expand_path("../../config/secrets.yml", __FILE__))
          encoded_secrets = Base64.strict_encode64("#{secrets['consumer_key']}:#{secrets['consumer_secret']}")
          oauth_token_url = YAML.load_file(File.expand_path("../../config/settings.yml", __FILE__))['twitter_oauth_token_url']
          [encoded_secrets, oauth_token_url]
        end
      end
    end
  end
end
