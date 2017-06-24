require 'redd'
require 'feedjira/podcast'
require 'yaml'

feeds = YAML::load_file('feeds.yml')
seen = YAML::load_file('state.yml')
credentials = YAML::load_file('credentials.yml')

reddit = Redd.it(
  user_agent: 'Redd:GoldenPheasant:v1.0.0 (by /u/mopoke)',
  client_id:  credentials[:client_id],
  secret:     credentials[:secret],
  username:   credentials[:username],
  password:   credentials[:password]
)

feeds.each do |name, url|
  xml = Faraday.get(url).body
  feed = Feedjira::Feed.parse xml

  feed.items.each do |item|
    seen[name] ||= {}
    unless seen[name][item.guid.guid]
      reddit.subreddit('gimlet').submit("#{feed.title} - #{item.title}", url: item.enclosure.url.to_s, sendreplies: false)
      seen[name][item.guid.guid] = true
    end
  end
end

File.open('state.yml', 'w') {|f| f.write seen.to_yaml }


