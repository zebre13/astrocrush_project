require 'rest-client'
require 'json'

class AstroApi

  def initialize
    @auth_token = auth_token["accessToken"]
  end

  def place_id(city_name, country_code)
    headers = { 'Accept-Encoding': "application/json", Authorization: "Bearer #{@auth_token}" }
    response = RestClient.post "https://api.bloom.be/api/places", {
      name: city_name,
      country_code: country_code
    }, headers
    JSON.parse(response)["data"].first["id"]
  end

  def natal_horoscope(username, birth_date, birth_time, place_id)
    headers = { 'Accept-Encoding': "application/json", Authorization: "Bearer #{@auth_token}" }
    response = RestClient.post "https://api.bloom.be/api/natal", {
      name: username,
      date: birth_date, # Format YYYY-MM-DD
      time: birth_time, # Format HH:MM
      place_id: place_id,
      lang: "en",
      system: "p"
    }, headers
    JSON.parse(response)
  end

  def compatibility(sign1_id, sign2_id)
    headers = { 'Accept-Encoding': "application/json", Authorization: "Bearer #{@auth_token}" }
    response = RestClient.post "https://api.bloom.be/api/signtosign", {
      sign1_id: sign1_id,
      sign2_id: sign2_id,
    }, headers
    JSON.parse(response)
  end

  private

  def auth_token
    response = RestClient.post 'https://api.bloom.be/api/auth', {
      email: ENV["API_LOGIN"],
      password: ENV["API_PWD"]
    }, { 'Accept-Encoding': "application/json" }
    JSON.parse(response)
  end
end

# p test = AstroApi.new
# city_id = test.place_id("Aix-en-Provence", "FR")
# p city_id
# p test.natal_horoscope("Boris", "1977-06-26", "05:30", city_id)
# # p test.compatibility(3, 7)
# p test.place_id("Paris", "FR")
# p test.place_id("Casablanca", "MA")
