require 'faraday'
require 'faraday_middleware'
require './lib/logging'

module Notifier
  class Twitter
    include Logging

    attr_reader :conn, :credentials

    def initialize(credentials)
      @credentials = credentials

      @conn = Faraday.new do |faraday|
        faraday.request :oauth, {
          consumer_key: credentials[:consumer_key],
          consumer_secret: credentials[:consumer_secret],
          token: credentials[:access_token],
          token_secret: credentials[:access_token_secret]
        }
        faraday.request :url_encoded
        faraday.adapter  Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json'
      end
    end

    def notify(item)
      status = item.feed.has_twitter? ? "New from @#{item.feed.twitter_handle}: " : ''
      status << "#{item.title} (#{item.url})"
      response = conn.post do |req|
        url = "https://api.twitter.com/1.1/statuses/update.json"
        req.url url
        req.params['status'] = status
      end
      logger.error "Twitter response was #{response.status}" unless response.success?
    end
  end
end
