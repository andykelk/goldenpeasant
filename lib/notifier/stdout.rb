module Notifier
  class Stdout
    def notify(item)
      puts "#{item.title} #{item.url} #{item.feed.has_twitter?} #{item.feed.twitter_handle}"
    end
  end
end
