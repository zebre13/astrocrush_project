# $redis = Redis.new

url = ENV["REDISCLOUD_URL"]

if url
  uri = URI.parse(url)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end
