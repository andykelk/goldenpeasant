require 'redd'

module Notifier
  class Reddit
    include Logging
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

    def notify title, url
      begin
        @reddit.subreddit('gimlet').submit(title, url: url, sendreplies: false)
      rescue Redd::APIError => e
        raise unless e.message =~ /already been submitted/
      end
    end
  end
end

