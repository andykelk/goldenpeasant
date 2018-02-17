require './lib/notifier/stdout'

describe Notifier::Stdout do
  it 'outputs to stdout' do
    expect { Notifier::Stdout.new.notify('Monkey', 'http://monkey.com/') }.to output("http://monkey.com/\tMonkey\n").to_stdout
  end
end
