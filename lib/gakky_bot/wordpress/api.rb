module GakkyBot
  module Wordpress
    class Api
      class << self
        def post(tweet)
          image_url, content = parse(tweet)
          if image_url.first.present?
            media_url = media(image_url, tweet["id_str"])
            body = media_url.map{|x| "<a href=#{x.first}><img src=#{x.first}></a>" }.join("<br/>") + "<br />" + content + "<br />" + "Source: <a href='https://twitter.com/i/web/status/#{tweet["id_str"]}' target='_blank'>https://twitter.com/i/web/status/#{tweet["id_str"]}</a>"
            featured_media = media_url[0][1]
          # else
          #   body = content + "<br />" + "Source: <a href='https://twitter.com/i/web/status/#{tweet["id_str"]}' target='_blank' >https://twitter.com/i/web/status/#{tweet["id_str"]}</a>"
          #   featured_media = SETTINGS['default_featured_media']
          end
          tweet_tags = tweet['entities']['hashtags'].map{|x| x['text']}
          tags = SETTINGS['default_tags']
          categories = SETTINGS['default_category']
          title = content.truncate(20, omission: "...")
          res = RestClient.post(SETTINGS["wordpress_post_url"],{title: title, content: body, author: SETTINGS['default_author'], status: "publish", tags: tags, categories: categories, featured_media: featured_media}, setup_headers)
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
            media_url << [result["guid"]["rendered"], result["id"]]
          end
          media_url
        end

        def get_tags(tags)
          tag_ids = []
          tags.each do |tag|
            if remote_tags[tag].present?
              tag_ids << remote_tags[tag]
            else
              tag_ids << create_tag(tag)
            end
          end
          tag_ids
        end

        def remote_tags
          JSON.parse(RestClient.get(SETTINGS['wordpress_tags_url'], setup_headers)).map{|x| [x['name'], x["id"]] }.to_h
        end

        def create_tag(tag)
          res = JSON.parse(RestClient.post(SETTINGS['wordpress_tags_url'], {name: tag, description: tag}, setup_headers))
          res["id"]
        end

        def parse(tweet)
          if tweet["truncated"]
            GakkyBot::WebScraper.extract(tweet["entities"]["urls"].first["expanded_url"])
          else
            media = [tweet["entities"]["media"]&.first&.[]("media_url")]
            media.concat(tweet["extended_entities"]["media"].map{|x| x["media_url"]}) if tweet["extended_entities"].present?
            [media, tweet["text"]]
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
