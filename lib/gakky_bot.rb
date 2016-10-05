lib = File.dirname(__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaml'
require 'base64'
require 'httparty'
require 'rest-client'
require 'active_record'
require 'active_support'
require 'nokogiri'
require 'open-uri'
require 'gakky_bot/version'
require 'gakky_bot/twitter/oauth'
require 'gakky_bot/twitter/api'
require 'gakky_bot/model/token'
require 'gakky_bot/model/history'
require 'gakky_bot/wordpress/api'
require 'gakky_bot/web_scraper'
require 'gakky_bot/image'

ActiveRecord::Base.establish_connection(YAML.load_file(File.expand_path("../gakky_bot/config/database.yml", __FILE__)))
SECRETS = YAML.load_file(File.expand_path("../gakky_bot/config/secrets.yml", __FILE__))
SETTINGS = YAML.load_file(File.expand_path("../gakky_bot/config/settings.yml", __FILE__))

module GakkyBot
  class << self
    def user_timeline
      SETTINGS['screen_names'].each do |screen_name|
        user_timeline =  Twitter::Api.user_timeline("#{screen_name}")
        JSON.parse(user_timeline.body).each do |tweet|
          next if Model::History.exists?(post_id: tweet['id_str'])
          Wordpress::Api.post(tweet) if tweet['entities']['hashtags'].map{|x| x['text']}.include?("新垣結衣")
        end
      end
    end
  end
end
GakkyBot.user_timeline
