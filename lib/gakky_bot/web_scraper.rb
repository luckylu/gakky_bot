require 'nokogiri'
require 'open-uri'
module GakkyBot
  class WebScraper
    class << self
      def extract(url)
        image_url = []
        html = Nokogiri::HTML(open(url))
        img_object = html.css(".AdaptiveMedia-photoContainer img")
        if img_object.present?
          img_object.each do |img|
            image_url << img.attr("src")
          end
        end
        content = html.css(".tweet-text").text.gsub(/(#.*)*/,"")
        [image_url, content]
      end
    end
  end
end
GakkyBot::WebScraper.extract("https://twitter.com/lespros_sec1/status/782012748947337217")
