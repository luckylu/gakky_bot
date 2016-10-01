module GakkyBot
  module Wordpress
    class Api
      class << self
        def post(tweet)
          image_url, content = parse(tweet)
          if image_url
            media_url = media(image_url, tweet["id_str"])
            body = media_url.map{|x| "<img src=#{x}>" }.join("<br/>") + "<br />" + content + "<br />" + "Source: <a href='https://twitter.com/lespros_sec1' target='_blank'>https://twitter.com/lespros_sec1</a>"
          else
            body = content + "<br />" + "Source: <a href='https://twitter.com/lespros_sec1' target='_blank' >https://twitter.com/lespros_sec1</a>"
          end
          title = content.truncate(20, omission: "...")
          res = RestClient.post(SETTINGS["wordpress_post_url"],{title: title, content: body, author: 2, status: "publish"}, setup_headers)
          GakkyBot::Model::History.create(post_id: tweet["id_str"]) if res.code == 201
        end

        def media(image_url, id)
          tmp = File.expand_path("../../../../tmp", __FILE__)
          Dir.mkdir(tmp) unless Dir.exist?(tmp)
          headers = setup_headers
          media_url = []
          GakkyBot::Image.process(image_url, id)
          image_url.each_with_index do |image, index|
            res = RestClient.post(SETTINGS['wordpress_media_url'], {status: 'publish', author: 1, file: File.new("#{tmp}/#{id}_#{index}.jpg")}, headers)
            result = JSON.parse(res)
            media_url << result["guid"]["rendered"]
          end
          media_url
        end

        def parse(tweet)
          if tweet["truncated"]
            GakkyBot::WebScraper.extract(tweet["entities"]["urls"].first["expanded_url"])
          else
            [tweet["entities"]["media"]&.first&.[]("media_url"), tweet["text"]]
          end
        end

        def setup_headers
          token = Base64.strict_encode64("#{SECRETS['wordpress_username']}:#{SECRETS['wordpress_key']}")
          {"Authorization" => "Basic #{token}", 'Content-Type' => 'application/octet-stream'}
        end
      end
    end
  end
end
