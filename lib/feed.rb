require 'nokogiri'
require 'faraday'
require './lib/parser/gimlet_media'
require './lib/parser/overcast'
require './lib/parser/spotify'

class Feed
  include Logging

  attr_accessor :seen, :name, :url, :twitter_handle

  def initialize(**opts)
    @name, @url, @seen, @twitter_handle = opts.values_at(:name, :url, :seen, :twitter_handle)
    @seen ||= {}
    validate!
  end

  def fetch_new
    logger.debug "Fetching #{url}"
    html = Nokogiri::HTML(Faraday.get(url).body)
    parser = if url =~ /overcast\.fm/
               Parser::Overcast.new
             elsif url =~ /spotify\.com/
               Parser::Spotify.new
             else
               Parser::GimletMedia.new
             end
    filter_seen(parser.parse(feed: self, html: html))
  end

  def filter_seen(items)
    new_items = []
    items.each do |item|
      logger.debug "URL #{item.url} seen: #{seen[item.url]}}"
      next if seen[item.url]

      logger.info "New episode #{item.url} for #{name}"
      new_items << item
      seen[item.url] = true
    end
    new_items
  end

  def has_twitter?
    twitter_handle != nil && twitter_handle.length > 0
  end

  private

  def validate!
    raise 'Missing name' if name.nil?
    raise 'Missing url' if url.nil?
  end
end
