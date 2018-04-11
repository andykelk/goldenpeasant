require 'uri'

module Parser
  class GimletMedia
    def parse(feed, feed_url)
      items = []
      feed_title = feed.at_css("meta[@property='og:title']")['content']
      feed_title.gsub!(/ - All Episodes$/i, '')

      feed.css('div.episode').each do |item|
        url = URI.join( feed_url, item.at_css('a')['href'] ).to_s
        title = item.at_css('h2.episode-title').content
        items << {url: url, title: "#{feed_title} - #{title}"}
      end
      items
    end
  end
end
