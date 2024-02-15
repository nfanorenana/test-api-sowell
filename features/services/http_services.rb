module HttpService
  include HTTParty

  base_uri CONFIG['default_url'].to_s
  headers 'Content-Type' => 'application/json'
  format :json
end
