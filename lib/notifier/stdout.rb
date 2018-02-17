module Notifier
  class Stdout
    def notify title, url
      puts "#{url}\t#{title}"
    end
  end
end

