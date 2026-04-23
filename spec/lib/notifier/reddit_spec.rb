require './lib/notifier/reddit'
require './spec/support/vcr_setup'

describe Notifier::Reddit do
  it 'connects and posts' do
    VCR.use_cassette 'reddit/api_response' do
      credentials = { username: 'blah', password: 'password', client_id: 'aAaAaAaAaAaAaA', secret: 'aAaAaAaAaAaAaAaAaaaAaaaAaA' }
      notifier = Notifier::Reddit.new(credentials)
      expect(notifier).to be_a(Notifier::Reddit)

      feed = double('feed', flair: 'podcast')
      item = double('item', title: 'Monkey', url: 'http://monkey.com/', feed: feed)
      expect { notifier.notify(item) }.to_not raise_error
    end
  end
end
