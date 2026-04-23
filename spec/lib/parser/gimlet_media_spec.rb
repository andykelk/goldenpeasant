require './lib/parser/gimlet_media'
require 'nokogiri'

describe Parser::GimletMedia do
  it "should return a new object" do
    expect(Parser::GimletMedia.new).to be_a(Parser::GimletMedia)
  end

  it "can parse an example page" do
    html = File.open(File.join('spec', 'fixtures', 'pages', 'uncivil.html')) { |f| Nokogiri::HTML(f) }
    feed = double('feed', url: 'https://www.gimletmedia.com/uncivil/all')
    items = Parser::GimletMedia.new.parse(feed: feed, html: html)
    expect(items).to be_a(Array)
    expect(items.length).to eq(12)
    items.each do |item|
      expect(item.url).to match(/^https:\/\/www.gimletmedia.com\/uncivil/)
      expect(item.title).to match(/^Uncivil - /)
    end
  end
end
