require './lib/notifier/stdout'

describe Notifier::Stdout do
  it 'outputs to stdout' do
    feed = double('feed', twitter_handle: '@test', has_twitter?: true)
    item = double('item', title: 'Monkey', url: 'http://monkey.com/', feed: feed)
    expect { Notifier::Stdout.new.notify(item) }.to output("Monkey http://monkey.com/ true @test\n").to_stdout
  end
end
