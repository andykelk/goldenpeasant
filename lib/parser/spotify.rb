require 'uri'
require './lib/item'

module Parser
  class Spotify
    def parse(**opts)
      feed, html = opts.values_at(:feed, :html)
      items = []
      feed_title = html.at_css('.media-bd h1').content

      html.css('li.tracklist-row').each do |item|
        a = item.at_css('a')
        url = URI.join(feed.url, a['href']).to_s
        title = item.at_css('span.track-name').content
        items << Item.new(url: url, title: "#{feed_title} - #{title}", feed: feed)
      end
      items
    end
  end
end
