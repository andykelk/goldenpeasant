require 'oauth'
require 'yaml'

BASE_URL = 'https://api.twitter.com'.freeze

def generate_authorize_uri(consumer, request_token)
  request = consumer.create_signed_request(:get, consumer.authorize_path, request_token, {oauth_callback: 'oob'})
  params = request['Authorization'].sub(/^OAuth\s+/, '').split(/,\s+/).collect do |param|
    key, value = param.split('=')
    value =~ /"(.*?)"/
    "#{key}=#{CGI.escape(Regexp.last_match[1])}"
  end.join('&')
  "#{BASE_URL}#{request.path}?#{params}"
end

def get_pin(uri)
  puts "Go to #{uri}"
  puts 'Then enter PIN:'
  gets
end

def get_access_token(credentials)
  consumer = OAuth::Consumer.new(credentials[:consumer_key], credentials[:consumer_secret], site: BASE_URL)
  request_token = consumer.get_request_token
  pin = get_pin(generate_authorize_uri(consumer, request_token))
  access_token = request_token.get_access_token(oauth_verifier: pin.chomp)
  access_token.get('/1.1/account/verify_credentials.json?skip_status=true')
  access_token
end

access_token = get_access_token(YAML.load_file('credentials.yml')[:twitter])
puts "access_token:#{access_token.token}\naccess_token_secret: #{access_token.secret}"
