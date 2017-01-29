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
require 'logger'
require 'slack-notifier'
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
$logger = Logger.new(File.expand_path("../../tmp/log/gakky_bot.log", __FILE__), 'weekly')
$logger.level = Logger::INFO
$notifier = Slack::Notifier.new SECRETS['webhook_url']


module GakkyBot
  class << self
    def user_timeline
      $notifier.ping '开始运行Gakky Bot'
      SETTINGS['screen_names'].each do |screen_name|
        user_timeline =  Twitter::Api.user_timeline("#{screen_name}")
        JSON.parse(user_timeline.body).each do |tweet|
          next if Model::History.exists?(post_id: tweet['id_str'])
          Wordpress::Api.post(tweet) if tweet['text'] =~ /新垣結衣/
        end
      end
    end
  end
end
begin
  GakkyBot.user_timeline
rescue => e
  $logger.fatal(e)
end
