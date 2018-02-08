module Notifier
  class Null
    def notify title, url
      puts "#{url}\t#{title}"
    end
  end
end

