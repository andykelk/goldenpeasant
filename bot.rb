require 'redd'
require 'nokogiri'
require 'faraday'
require 'yaml'
require 'logger'

$logger = Logger.new 'goldenpeasant.log'
$logger.sev_threshold = Logger::INFO

$logger.info "Starting check"

feeds = YAML::load_file('feeds.yml')
$seen = YAML::load_file('state.yml')
credentials = YAML::load_file('credentials.yml')

$reddit = Redd.it(
  user_agent: 'Redd:GoldenPheasant:v1.0.0 (by /u/mopoke)',
  client_id:  credentials[:client_id],
  secret:     credentials[:secret],
  username:   credentials[:username],
  password:   credentials[:password]
)

$logger.debug "Connected to reddit as #{credentials[:username]}"

def process_gimlet(feed, feed_name, feed_url)
  feed_title = feed.at_css("meta[@property='og:title']")['content']
  feed_title.gsub!(/ (?:-|by) Gimlet Media$/i, '')

  feed.css('h3.list__item__title').each do |item|
    url = item.at_css('a')['href']
    title = item.at_css('a').content
    check_url(url, title, feed_title, feed_name)
  end
end

def process_overcast(feed, feed_name, feed_url)
  feed_title = feed.at_css('h2.centertext').content

  feed.css('a.usernewepisode').each do |item|
    url = URI.join(feed_url, item['href']).to_s
    title = item.at_css('div.title').content
    check_url(url, title, feed_title, feed_name)
  end
end

def check_url(url, title, feed_title, feed_name)
  $seen[feed_name] ||= {}
  $logger.debug "URL #{url} seen: #{$seen[feed_name][url]}}"
  unless $seen[feed_name][url]
    $logger.info "New episode #{url} for #{feed_title} - #{title}"
    begin
      $reddit.subreddit('gimlet').submit("#{feed_title} - #{title}", url: url, sendreplies: false)
    rescue Redd::APIError => e
      raise unless e.message =~ /already been submitted/
    ensure
      $seen[feed_name][url] = true
    end
  end
end

feeds.each do |feed_name, feed_url|
  $logger.debug "Fetching #{feed_url}"
  html = Faraday.get(feed_url).body
  feed = Nokogiri::HTML(html)
  if feed_url =~ /overcast\.fm/
    process_overcast(feed, feed_name, feed_url)
  else
    process_gimlet(feed, feed_name, feed_url)
  end
end

File.open('state.yml', 'w') {|f| f.write $seen.to_yaml }

$logger.info "Finished check"

