require 'vcr'
require 'webmock'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
end
WebMock.disable_net_connect!
