# $redis = Redis.new

url = ENV["REDIS_PROVIDER"]

if url
  uri = URI.parse(url)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end
