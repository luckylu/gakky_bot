lib = File.dirname(__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaml'
require 'base64'
require 'httparty'
require 'active_record'
require 'gakky_bot/version'
require 'gakky_bot/twitter/oauth'
require 'gakky_bot/twitter/api'
require 'gakky_bot/model/token'

ActiveRecord::Base.establish_connection(YAML.load_file(File.expand_path("../gakky_bot/config/database.yml", __FILE__)))

module GakkyBot
  class << self
    def user_timeline
      puts Twitter::Api.user_timeline(Twitter::Oauth.bearer_token, 'lespros_sec1')
    end
  end
end
GakkyBot.user_timeline
