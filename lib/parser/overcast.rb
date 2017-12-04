module Parser
  class Overcast
    def parse(feed, feed_url)
      items = []
      feed_title = feed.at_css('h2.centertext').content

      feed.css('a.usernewepisode').each do |item|
        url = URI.join(feed_url, item['href']).to_s
        title = item.at_css('div.title').content
        items << {url: url, title: "#{feed_title} - #{title}"}
      end
      items
    end
  end
end
