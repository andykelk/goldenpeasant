require 'yaml'
require './lib/logging'
require './lib/feed'
require './lib/notifier/reddit'
require './lib/notifier/null'

class Bot
  include Logging

  def initialize feeds, credentials, options
    if options[:debug]
      logger.sev_threshold = Logger::DEBUG
    else
      logger.sev_threshold = Logger::INFO
    end

    seen = YAML::load_file('state.yml')
    @feeds = []
    feeds.each do |feed_name, feed_url|
      @feeds << Feed.new(feed_name, feed_url, (seen.class == Hash && seen.key?(feed_name) ? seen[feed_name] : {}))
    end
    if options[:debug]
      @notifier = Notifier::Null.new()
    else
      @notifier = Notifier::Reddit.new(credentials)
    end
  end

  def run
    logger.info "Starting check"
    @feeds.each do |feed|
      feed.fetch_new.each do |item|
        @notifier.notify(item[:title], item[:url]);
      end
    end
    File.open('state.yml', 'w') {|f| f.write @feeds.map{|feed| [feed.name, feed.seen] }.to_h.to_yaml }
    logger.info "Finished check"
  end

end
