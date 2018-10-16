class Item
  include Logging

  attr_accessor :title, :url, :feed

  def initialize(**opts)
    @title, @url, @feed = opts.values_at(:title, :url, :feed)
    validate!
  end

  private

  def validate!
    raise 'Missing title' if title.nil?
    raise 'Missing url' if url.nil?
    raise 'Missing feed' if feed.nil?
  end
end
