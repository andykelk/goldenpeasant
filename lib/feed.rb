require 'nokogiri'
require 'faraday'
require './lib/parser/gimlet_media'
require './lib/parser/overcast'
require './lib/parser/spotify'

class Feed
  include Logging

  attr_reader :seen
  attr_reader :name

  def initialize(name, url, seen)
    @name = name
    @url = url
    @seen = seen || {}
  end

  def fetch_new
    logger.debug "Fetching #{@url}"
    html = Faraday.get(@url).body
    feed = Nokogiri::HTML(html)
    if @url =~ /overcast\.fm/
      parser = Parser::Overcast.new
    elsif @url =~ /spotify\.com/
      parser = Parser::Spotify.new
    else
      parser = Parser::GimletMedia.new
    end
    filter_seen(parser.parse(feed, @url))
  end

  def filter_seen(items)
    new_items = []
    items.each do |item|
      logger.debug "URL #{item[:url]} seen: #{@seen[item[:url]]}}"
      unless @seen[item[:url]]
        logger.info "New episode #{item[:url]} for #{@name}"
        new_items << item
        @seen[item[:url]] = true
      end
    end
    new_items
  end
end
