require 'redd'
require 'nokogiri'
require 'faraday'
require 'yaml'
require 'logger'

logger = Logger.new 'goldenpeasant.log'
logger.sev_threshold = Logger::INFO

logger.info "Starting check"

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

logger.debug "Connected to reddit as #{credentials[:username]}"

feeds.each do |name, url|
  logger.debug "Fetching #{url}"
  html = Faraday.get(url).body
  feed = Nokogiri::HTML(html)
  feed_title = feed.at_css("meta[@property='og:title']")['content']
  feed_title.gsub!(/ - Gimlet Media$/i, '')

  feed.css('h3.list__item__title').each do |item|
    url = item.at_css('a')['href']
    title = item.at_css('a').content
    seen[name] ||= {}
    logger.debug "URL #{url} seen: #{seen[name][url]}}"
    unless seen[name][url]
      logger.info "New episode #{url} for #{feed_title} - #{title}"
      reddit.subreddit('gimlet').submit("#{feed_title} - #{title}", url: url, sendreplies: false)
      seen[name][url] = true
    end
  end
end

File.open('state.yml', 'w') {|f| f.write seen.to_yaml }

logger.info "Finished check"
