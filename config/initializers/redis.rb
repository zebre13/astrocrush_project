# $redis = Redis.new

# url = ENV["REDISCLOUD_URL"]

if url
  uri = URI.parse(url || "redis://localhost:6379/" )
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end
