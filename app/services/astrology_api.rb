require 'net/http'

user_id = ENV["API_UID"]
api_key = ENV["API_KEY"]

class Client
  @@base_url = "http://json.astrologyapi.com/v1/" # Remettre https lorsqu'une solution aura été trouvée avec net/http

  def initialize(uid = nil, key = nil)
    @user_id = uid
    @api_key = key
  end

  def get_response(endpoint, data)
    url = URI.parse(@@base_url+endpoint)
    req = Net::HTTP::Post.new(url)
    req.basic_auth @user_id, @api_key
    req.set_form_data(data)
    resp = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
    puts resp.body
  end
end


# <--- Test du endpoint "western_horoscope" --->

endpoint = "western_horoscope"
data = {
  day: 26,
  month: 6,
  year: 1977,
  hour: 5,
  min: 30,
  lat: 43.529742,
  lon: 5.447427,
  tzone: 2
}
client = Client.new(user_id, api_key)
data = client.get_response(endpoint, data)
p data


# <--- Test du endpoint "personality_report/tropical" --->

# endpoint = "personality_report/tropical"
# data = {
#   day: 26,
#   month: 6,
#   year: 1977,
#   hour: 5,
#   min: 30,
#   lat: 43.529742,
#   lon: 5.447427,
#   tzone: 2
# }
# client = Client.new(user_id, api_key)
# data = client.get_response(endpoint, data)
# p data


# <--- Test du endpoint "affinity_calculator" --->

# endpoint = "affinity_calculator"
# data = {
#   p_day: 26,
#   p_month: 6,
#   p_year: 1977,
#   p_hour: 5,
#   p_min: 30,
#   p_lat: 43.529742,
#   p_lon: 5.447427,
#   p_tzone: 2,
#   s_day: 1,
#   s_month: 11,
#   s_year: 1976,
#   s_hour: 18,
#   s_min: 30,
#   s_lat: 43.6961,
#   s_lon: 7.27178,
#   s_tzone: 2
# }
# client = Client.new(user_id, api_key)
# data = client.get_response(endpoint, data)
# p data


# <--- Test du endpoint "natal_wheel_chart" --->

# endpoint = "natal_wheel_chart"
# data = {
#   day: 26,
#   month: 6,
#   year: 1977,
#   hour: 5,
#   min: 30,
#   lat: 43.529742,
#   lon: 5.447427,
#   tzone: 2
# }
# client = Client.new(user_id, api_key)
# data = client.get_response(endpoint, data)
# p data


# <--- Test du endpoint "timezone_with_dst" --->

# endpoint = "timezone_with_dst"
# data = {
#   latitude: 43.529742,
#   longitude: 5.447427,
#   date: "6-26-1977"
# }
# client = Client.new(user_id, api_key)
# data = client.get_response(endpoint, data)
# p data


# <--- Test du endpoint "zodiac_compatibility/:zodiacName/:partnerZodiacName" --->

# endpoint = "zodiac_compatibility/leo/sagittarius"
# data = {}
# client = Client.new(user_id, api_key)
# data = client.get_response(endpoint, data)
# p data


# <--- Test du endpoint "zodiac_compatibility/:zodiacName/:partnerZodiacName" --->

# endpoint = "zodiac_compatibility/leo/sagittarius"
# data = {}
# client = Client.new(user_id, api_key)
# data = client.get_response(endpoint, data)
# p data


# <--- Test du endpoint "zodiac_compatibility/:zodiacName" --->

# endpoint = "zodiac_compatibility/aquarius"
# data = {}
# client = Client.new(user_id, api_key)
# data = client.get_response(endpoint, data)
# p data


# <--- Test du endpoint "compatibility/:sunSign/:risingSign/:partnerSunSign/:partnerRisingSign" --->

# endpoint = "compatibility/aquarius/gemini/gemini/scorpio"
# data = {}
# client = Client.new(user_id, api_key)
# data = client.get_response(endpoint, data)
# p data
