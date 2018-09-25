require 'uri'

module Parser
  class Spotify
    def parse(feed, feed_url)
      items = []
      feed_title = feed.at_css('.media-bd h1').content

      feed.css('li.tracklist-row').each do |item|
        a = item.at_css('a')
        url = URI.join(feed_url, a['href']).to_s
        title = item.at_css('span.track-name').content
        items << {url: url, title: "#{feed_title} - #{title}"}
      end
      items
    end
  end
end
