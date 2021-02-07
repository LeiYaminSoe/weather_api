class Rack::Attack

  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  #can set localhost as whitelist, if so
  #localhost can call any amount of request
  #whitelist('allow-localhost') do |req|
  #  '127.0.0.1' == req.ip || '::1' == req.ip
  #end

  #limit only 10000 request to third party API
  #throttle('req/ip', :limit => 7, :period => 24.hours) do |req|
  throttle('req/ip', :limit => 10000, :period => 24.hours) do |req|
    req.ip
  end

  self.throttled_response = ->(env) {
    retry_after = (env['rack.attack.match_data'] || {})[:period]
    [
      429,
      {'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s},
      [{"cod":"429","error":"API request daily limit of 10000 has reached. Retry later day."}.to_json]
    ]
  }
end
