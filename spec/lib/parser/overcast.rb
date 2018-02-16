require './lib/parser/overcast'
require 'nokogiri'

describe Parser::Overcast do
  it "should return a new object" do
    expect(Parser::Overcast.new).to be_a(Parser::Overcast)
  end

  it "can parse an example page" do
    feed = File.open(File.join('spec', 'fixtures', 'pages', 'uncivil-overcast.html')) { |f| Nokogiri::HTML(f) }
    items = Parser::Overcast.new.parse(feed, 'https://overcast.fm/itunes1275078406/uncivil')
    expect(items).to be_a(Array)
    expect(items.length).to eq(13)
    items.each do |item|
      expect(item[:url]).to match(/^https:\/\/overcast\.fm\/\+/)
      expect(item[:title]).to match(/^Uncivil - /)
    end
  end
end
