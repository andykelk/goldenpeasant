require 'redd'
require './lib/logging'

module Notifier
  class Reddit
    include Logging

    attr_reader :reddit

    def initialize(credentials)
      @reddit = Redd.it(
        user_agent: 'Redd:GoldenPheasant:v1.0.0 (by /u/mopoke)',
        client_id:  credentials[:client_id],
        secret:     credentials[:secret],
        username:   credentials[:username],
        password:   credentials[:password]
      )
      logger.debug "Connected to reddit as #{credentials[:username]}"
    end

    def notify(item)
      begin
        link = reddit.subreddit('gimlet').submit(item.title, url: item.url, sendreplies: false)
        reddit.subreddit('gimlet').set_flair(link, item.feed.flair)
      rescue Redd::APIError => e
        raise unless e.message =~ /already been submitted/
      end
    end
  end
end
