require './lib/parser/gimlet_media'
require 'nokogiri'

describe Parser::GimletMedia do
  it "should return a new object" do
    expect(Parser::GimletMedia.new).to be_a(Parser::GimletMedia)
  end

  it "can parse an example page" do
    feed = File.open(File.join('spec', 'fixtures', 'pages', 'uncivil.html')) { |f| Nokogiri::HTML(f) }
    items = Parser::GimletMedia.new.parse(feed, 'https://www.gimletmedia.com/uncivil/all')
    expect(items).to be_a(Array)
    expect(items.length).to eq(12)
    items.each do |item|
      expect(item[:url]).to match(/^https:\/\/www.gimletmedia.com\/uncivil/)
      expect(item[:title]).to match(/^Uncivil - /)
    end
  end
end
