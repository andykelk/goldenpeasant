require 'yaml'
require './lib/bot'
require 'optparse'

options = {}
OptionParser.new do |opt|
  opt.on('--debug') { options[:debug] = true }
end.parse!

Bot.new(YAML.load_file('feeds.yml'), YAML.load_file('credentials.yml'), options).run
