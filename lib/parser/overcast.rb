require 'uri'
require './lib/item'

module Parser
  class Overcast
    def parse(**opts)
      feed, html = opts.values_at(:feed, :html)
      items = []
      feed_title = html.at_css('h2.centertext').content

      html.css('a.usernewepisode').each do |item|
        url = URI.join(feed.url, item['href']).to_s
        title = item.at_css('div.title').content
        items << Item.new(url: url, title: "#{feed_title} - #{title}", feed: feed)
      end
      items
    end
  end
end
