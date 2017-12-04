require 'yaml'
require './lib/bot'

Bot.new(YAML::load_file('feeds.yml'), YAML::load_file('credentials.yml')).run
