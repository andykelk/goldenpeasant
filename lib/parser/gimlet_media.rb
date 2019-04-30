require 'uri'
require './lib/item'

module Parser
  class GimletMedia
    def parse(**opts)
      feed, html = opts.values_at(:feed, :html)
      items = []
      feed_title = html.at_css("meta[@property='og:title']")['content']
      feed_title.gsub!(/^Episodes \| /i, '')

      html.css('div.episode-card').each do |item|
        url = URI.join(feed.url, item.at_css('a')['href']).to_s
        title = item.at_css('p.episode-title').content.strip
        items << Item.new(url: url, title: "#{feed_title} - #{title}", feed: feed)
      end
      items
    end
  end
end
