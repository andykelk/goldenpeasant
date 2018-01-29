module Parser
  class GimletMedia
    def parse(feed, feed_url)
      items = []
      feed_title = feed.at_css("meta[@property='og:title']")['content']
      feed_title.gsub!(/ (?:-|by|- a podcast from) Gimlet Media$/i, '')

      feed.css('h3.list__item__title').each do |item|
        url = item.at_css('a')['href']
        title = item.at_css('a').content
        items << {url: url, title: "#{feed_title} - #{title}"}
      end
      items
    end
  end
end
