# redd 0.8.8 passes hashes positionally where Ruby 3 requires **splat for keyword args
module Redd
  class << self
    private

    def script(opts = {})
      return unless %i[client_id secret username password].all? { |o| opts.include?(o) }
      auth = AuthStrategies::Script.new(**filter_auth(opts))
      api = APIClient.new(auth, **filter_api(opts))
      api.tap(&:authenticate)
    end

    def userless(opts = {})
      return unless %i[client_id secret].all? { |o| opts.include?(o) }
      auth = AuthStrategies::Userless.new(**filter_auth(opts))
      api = APIClient.new(auth, **filter_api(opts))
      api.tap(&:authenticate)
    end
  end
end
