require 'yaml'
require './lib/logging'
require './lib/feed'
require './lib/notifier/reddit'
require './lib/notifier/twitter'
require './lib/notifier/stdout'

class Bot
  include Logging

  attr_accessor :feeds, :notifiers

  def initialize(feeds, credentials, options)
    logger.sev_threshold = options[:debug] ? Logger::DEBUG : Logger::INFO
    setup_feeds(feeds)
    setup_notifiers(credentials, options)
  end

  def run
    logger.info 'Starting check'
    feeds.each do |feed|
      feed.fetch_new.each do |item|
        notifiers.each do |notifier|
          notifier.notify(item[:title], item[:url])
        end
      end
    end
    File.open('state.yml', 'w') { |f| f.write feeds.map { |feed| [feed.name, feed.seen] }.to_h.to_yaml }
    logger.info 'Finished check'
  end

  private

  def setup_feeds(feeds)
    seen = YAML.load_file('state.yml')
    @feeds = []
    feeds.each do |feed_name, feed|
      @feeds << Feed.new(
        name: feed_name, url: feed[:url],
        seen: (seen.class == Hash && seen.key?(feed_name) ? seen[feed_name] : {})
      )
    end
  end

  def setup_notifiers(credentials, options)
    @notifiers = []
    if options[:debug]
      @notifiers << Notifier::Stdout.new
    else
      @notifiers << Notifier::Reddit.new(credentials[:reddit])
      @notifiers << Notifier::Twitter.new(credentials[:twitter])
    end
  end
end
