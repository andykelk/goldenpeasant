require './lib/notifier/reddit'
require './spec/support/vcr_setup'

describe Notifier::Reddit do
  it 'outputs to stdout' do
    VCR.use_cassette 'reddit/api_response' do
      credentials = { username: 'blah', password: 'password', client_id: 'aAaAaAaAaAaAaA', secret: 'aAaAaAaAaAaAaAaAaaaAaaaAaA' }
      notifier = Notifier::Reddit.new(credentials)
      expect(notifier).to be_a(Notifier::Reddit)
      expect{notifier.notify('Monkey', 'http://monkey.com/')}.to_not raise_error
    end
  end
end
