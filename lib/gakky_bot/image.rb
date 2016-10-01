module GakkyBot
  class Image
    class << self
      def process(image_url, id)
        tmp = File.expand_path("../../../tmp", __FILE__)
        image_url.each_with_index do |image, index|
          open(image) do |f|
            File.open("#{tmp}/#{id}_#{index}.jpg", "wb") do |file|
              file.puts f.read
            end
          end
        end
      end
    end
  end
end
