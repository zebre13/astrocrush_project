require 'net/http'
require 'json'
require 'date'
require 'time'

api_uid = "619845"
api_key = "0fe9a97cde1e13cefe57c49cf2643167"

class Call
  @@base_url = "http://json.astrologyapi.com/v1/" # Remettre https lorsqu'une solution aura été trouvée avec net/http

  def initialize(uid = nil, key = nil)
    @api_uid = uid
    @api_key = key
  end

  # Renvoie les données brutes d'un horoscope
  def horoscope(birth_date, birth_hour, city, country_code)
    endpoint = "western_horoscope"
    data = birth_data_set(birth_date, birth_hour, city, country_code)
    return get_response(endpoint, data)
  end

  # Renvoie la position des 10 planètes en signes et maisons sous forme de hash (key = planète) d'arrays (value = [signe, maison])
  def planets_location(birth_date, birth_hour, city, country_code)
    horo_elements = horoscope(birth_date, birth_hour, city, country_code)['planets']
    planets = { Sun: {}, Moon: {}, Mars: {}, Mercury: {}, Jupiter: {}, Venus: {}, Saturn: {}, Uranus: {}, Neptune: {}, Pluto: {} }
    planets.each_key do |key|
      horo_elements.each do |element|
        planets[key] = { sign: element['sign'], house: element['house'] } if element['name'] == key.to_s
      end
    end
    return planets
  end

  # Renvoie l'url de la carte du ciel en format svg
  def wheel_chart(birth_date, birth_hour, city, country_code)
    endpoint = "natal_wheel_chart"
    data = birth_data_set(birth_date, birth_hour, city, country_code)
    return get_response(endpoint, data)['chart_url']
  end

  # Renvoie un texte présentant la personalité d'une personne en fonction de ses éléments de naissance
  def personality_report(birth_date, birth_hour, city, country_code)
    endpoint = "personality_report/tropical"
    data = birth_data_set(birth_date, birth_hour, city, country_code)
    return get_response(endpoint, data)['report']
  end

  # Affinity percentage between primary user (p) and secondary mate (s)
  def affinity_percentage(p_birth_date, p_birth_hour, p_city, p_country_code, s_birth_date, s_birth_hour, s_city, s_country_code)
    endpoint = "affinity_calculator"
    p_data = p_birth_data_set(p_birth_date, p_birth_hour, p_city, p_country_code)
    s_data = s_birth_data_set(s_birth_date, s_birth_hour, s_city, s_country_code)
    data = p_data.merge(s_data)
    return get_response(endpoint, data)['affinity_percentage']
  end

  # Get love compatibility report for relationship between primary user (p) and secondary mate (s)
  def love_compatibility_report(p_birth_date, p_birth_hour, p_city, p_country_code, s_birth_date, s_birth_hour, s_city, s_country_code)
    endpoint = "love_compatibility_report/tropical"
    p_data = p_birth_data_set(p_birth_date, p_birth_hour, p_city, p_country_code)
    s_data = s_birth_data_set(s_birth_date, s_birth_hour, s_city, s_country_code)
    data = p_data.merge(s_data)
    return get_response(endpoint, data)['love_report']
  end

  # Call de l'api
  def get_response(endpoint, data)
    url = URI.parse(@@base_url+endpoint)
    req = Net::HTTP::Post.new(url)
    req.basic_auth @api_uid, @api_key
    req.set_form_data(data)
    resp = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
    JSON.parse(resp.body)
  end

  # Renvoie les coordonnées (lat/lon) d'une ville à partir de son nom (ex: "Paris") et de son code pays (ex: "FR")
  def city_coord(city, country_code)
    endpoint = "geo_details"
    data = { place: city.capitalize, maxRows: 6 }
    cities = get_response(endpoint, data)
    city = cities['geonames'].select { |item| item['country_code'] == country_code.upcase }
    return { lat: city.first['latitude'], lon: city.first['longitude'] }
  end

  # Renvoie le code de la timezone d'un lieu en fonction de ses coordonnées géographiques et de la date ("dd/mm/yyyy")
  def time_zone(lat, lon, birth_date)
    endpoint = "timezone_with_dst"
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    data = {
      latitude: lat.to_i,
      longitude: lon.to_i,
      date: birth_date.strftime("%-m-%-d-%Y")
    }
    info = get_response(endpoint, data)
    return info['timezone']
  end

  # Renvoie un hash contenant les données de naissance formattées pour l'usage de l'api à partir des éléments de naissance
  def birth_data_set(birth_date, birth_hour, city, country_code)
    coord = city_coord(city, country_code)
    tzone = time_zone(coord[:lat], coord[:lon], birth_date)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    birth_hour = birth_hour.is_a?(String) ? Time.parse(birth_hour) : birth_hour
    data = {
      day: birth_date.day,
      month: birth_date.month,
      year: birth_date.year,
      hour: birth_hour.hour,
      min: birth_hour.min,
      lat: coord[:lat],
      lon: coord[:lon],
      tzone: tzone
    }
  end

  # Renvoie un hash contenant les données de naissance formattées pour la première personne dans un calcul d'affinité
  def p_birth_data_set(birth_date, birth_hour, city, country_code)
    coord = city_coord(city, country_code)
    tzone = time_zone(coord[:lat], coord[:lon], birth_date)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    birth_hour = birth_hour.is_a?(String) ? Time.parse(birth_hour) : birth_hour
    data = {
      p_day: birth_date.day,
      p_month: birth_date.month,
      p_year: birth_date.year,
      p_hour: birth_hour.hour,
      p_min: birth_hour.min,
      p_lat: coord[:lat],
      p_lon: coord[:lon],
      p_tzone: tzone
    }
  end

  # Renvoie un hash contenant les données de naissance formattées pour la deuxième personne dans un calcul d'affinité
  def s_birth_data_set(birth_date, birth_hour, city, country_code)
    coord = city_coord(city, country_code)
    tzone = time_zone(coord[:lat], coord[:lon], birth_date)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    birth_hour = birth_hour.is_a?(String) ? Time.parse(birth_hour) : birth_hour
    data = {
      s_day: birth_date.day,
      s_month: birth_date.month,
      s_year: birth_date.year,
      s_hour: birth_hour.hour,
      s_min: birth_hour.min,
      s_lat: coord[:lat],
      s_lon: coord[:lon],
      s_tzone: tzone
    }
  end
end

# <--- Test du endpoint "zodiac_compatibility/:zodiacName" --->
# endpoint = "zodiac_compatibility/aquarius"
# data = {}
# client = Client.new(api_uid, api_key)
# data = client.get_response(endpoint, data)
# p data

# <--- Test du endpoint "zodiac_compatibility/:zodiacName/:partnerZodiacName" --->
# endpoint = "zodiac_compatibility/leo/sagittarius"
# data = {}
# client = Client.new(api_uid, api_key)
# data = client.get_response(endpoint, data)
# p data

# <--- Test du endpoint "compatibility/:sunSign/:risingSign/:partnerSunSign/:partnerRisingSign" --->
# endpoint = "compatibility/aquarius/gemini/gemini/scorpio"
# data = {}
# client = Client.new(api_uid, api_key)
# data = client.get_response(endpoint, data)
# p data
