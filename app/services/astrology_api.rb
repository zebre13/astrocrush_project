require 'net/http'
require 'json'
require 'date'
require 'time'

user_id = "619845"
api_key = "0fe9a97cde1e13cefe57c49cf2643167"

class Call
  @@base_url = "http://json.astrologyapi.com/v1/" # Remettre https lorsqu'une solution aura été trouvée avec net/http

  def initialize(uid = nil, key = nil)
    @user_id = uid
    @api_key = key
  end

  # Renvoie les données brutes servant à bâtir un horoscope
  # *** ATTENTION *** Remplacer city et country_code par birth_location une fois ajusté le format de birth_location (Ville (Etat/Region), Country_code)
  def horoscope(birth_date, birth_hour, city, country_code)
    endpoint = "western_horoscope"
    data = birth_data_set(birth_date, birth_hour, city, country_code)
    return get_response(endpoint, data)
  end

  # Renvoie la position des 10 planètes en signes et maisons sous forme de hash (key = planète) d'arrays (value = [signe, maison])
  def planets_location(birth_date, birth_hour, city, country_code)
    horo_elements = horoscope(birth_date, birth_hour, city, country_code)['planets']
    planets = { Sun: [], Moon: [], Mars: [], Mercury: [], Jupiter: [], Venus: [], Saturn: [], Uranus: [], Neptune: [], Pluto: [] }
    planets.each_key do |key|
      horo_elements.each do |element|
        planets[key] = [element['sign'], element['house']] if element['name'] == key.to_s
      end
    end
    return planets
  end

  # Renvoie l'url de la carte du ciel en format svg
  # *** ATTENTION *** Remplacer city et country_code par birth_location une fois ajusté le format de birth_location (Ville (Etat/Region), Country_code)
  def natal_wheel_chart(birth_date, birth_hour, city, country_code)
    endpoint = "natal_wheel_chart"
    data = birth_data_set(birth_date, birth_hour, city, country_code)
    return get_response(endpoint, data)['chart_url']
  end

  # Renvoie un texte présentant la personalité d'une personne en fonction de ses éléments de naissance
  def personality_report(birth_date, birth_hour, city, country_code)
    endpoint = "personality_report/tropical"
    data = birth_data_set(birth_date, birth_hour, city, country_code)
    return get_response(endpoint, data)
  end

  def affinity_percentage(p_birth_date, p_birth_hour, p_city, p_country_code, s_birth_date, s_birth_hour, s_city, s_country_code)
    endpoint = "affinity_calculator"
    p_data = p_birth_data_set(p_birth_date, p_birth_hour, p_city, p_country_code)
    s_data = s_birth_data_set(s_birth_date, s_birth_hour, s_city, s_country_code)
    data = p_data.merge(s_data)
    return get_response(endpoint, data)['affinity_percentage']
  end

  # private

  def get_response(endpoint, data)
    url = URI.parse(@@base_url+endpoint)
    req = Net::HTTP::Post.new(url)
    req.basic_auth @user_id, @api_key
    req.set_form_data(data)
    resp = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
    JSON.parse(resp.body)
  end

    # Renvoie les coordonnées (lat/lon) d'une ville à partir de son nom (ex: "Paris") et de son code pays (ex: "FR")
  # *** ATTENTION *** Remplacer city et country_code par birth_location une fois ajusté le format de birth_location (Ville (Etat/Region), Country_code)
  def city_coord(city, country_code)
    endpoint = "geo_details"
    data = {
      place: city.capitalize,
      maxRows: 6 }
    cities = get_response(endpoint, data)
    city = cities['geonames'].select { |item| item['country_code'] == country_code.upcase }
    return { lat: city.first['latitude'], lon: city.first['longitude'] }
  end

  # Renvoie le code de la timezone d'un lieu en fonction de ses coordonnées géographiques et de la date ("dd/mm/yyyy")
  def time_zone(lat, lon, birth_date)
    endpoint = "timezone_with_dst"
    data = {
      latitude: lat.to_i,
      longitude: lon.to_i,
      date: Date.parse(birth_date).strftime("%-m-%-d-%Y")
    }
    info = get_response(endpoint, data)
    return info['timezone']
  end

  # Renvoie un hash contenant les données de naissance formattées pour l'usage de l'api à partir des éléments de naissance
  def birth_data_set(birth_date, birth_hour, city, country_code)
    coord = city_coord(city, country_code)
    tzone = time_zone(coord[:lat], coord[:lon], birth_date)
    data = {
      day: birth_date.split('/').first.to_i,
      month: birth_date.split('/')[1].to_i,
      year: birth_date.split('/')[2].to_i,
      hour: birth_hour.split(':').first.to_i,
      min: birth_hour.split(':').last.to_i,
      lat: coord[:lat],
      lon: coord[:lon],
      tzone: tzone
    }
  end

  # Renvoie un hash contenant les données de naissance formattées pour la première personne dans un calcul d'affinité
  def p_birth_data_set(birth_date, birth_hour, city, country_code)
    coord = city_coord(city, country_code)
    tzone = time_zone(coord[:lat], coord[:lon], birth_date)
    data = {
      p_day: birth_date.split('/').first.to_i,
      p_month: birth_date.split('/')[1].to_i,
      p_year: birth_date.split('/')[2].to_i,
      p_hour: birth_hour.split(':').first.to_i,
      p_min: birth_hour.split(':').last.to_i,
      p_lat: coord[:lat],
      p_lon: coord[:lon],
      p_tzone: tzone
    }
  end

  # Renvoie un hash contenant les données de naissance formattées pour la deuxième personne dans un calcul d'affinité
  def s_birth_data_set(birth_date, birth_hour, city, country_code)
    coord = city_coord(city, country_code)
    tzone = time_zone(coord[:lat], coord[:lon], birth_date)
    data = {
      s_day: birth_date.split('/').first.to_i,
      s_month: birth_date.split('/')[1].to_i,
      s_year: birth_date.split('/')[2].to_i,
      s_hour: birth_hour.split(':').first.to_i,
      s_min: birth_hour.split(':').last.to_i,
      s_lat: coord[:lat],
      s_lon: coord[:lon],
      s_tzone: tzone
    }
  end
end

# <--- Instanciation d'appel de l'api --->
call = Call.new(user_id, api_key)

# <--- Test de la méthode "city_coord" --->
# coord = call.city_coord("Aix-en-Provence", "FR")
# p coord

# <--- Test de la méthode "timezone" --->
# tzone = call.time_zone(coord[:lat], coord[:lon], "26/06/1977")
# p tzone

# <--- Test de la méthode "birth_data_set" --->
# data = call.birth_data_set("26/06/1977", "05:30", "Aix-en-Provence", "FR")
# p data

# <--- Test de la méthode "horoscope" --->
# horo = call.horoscope("26/06/1977", "05:30", "Aix-en-Provence", "FR")
# p horo

# <--- Test de la méthode "planets_location" --->
# planets = call.planets_location("26/06/1977", "05:30", "Aix-en-Provence", "FR")
# p planets

# <--- Test de la méthode "natal_wheel_chart" --->
# natal_wheel_chart = call.natal_wheel_chart("26/06/1977", "05:30", "Aix-en-Provence", "FR")
# p natal_wheel_chart

# <--- Test de la méthode "personality_report" --->
# personality_report = call.personality_report("26/06/1977", "05:30", "Aix-en-Provence", "FR")
# p personality_report

# <--- Test de la méthode "affinity_percentage" ---> *** ATTENTION *** Cette méthode donne un résultat différent à chaque appel (???)
# score = call.affinity_percentage("26/06/1977", "05:30", "Aix-en-Provence", "FR", "28/05/1982", "18:30", "Le Chesnay", "FR")
# p score

# <========== REPRENDRE ICI ==========>

# <--- Test du endpoint "zodiac_compatibility/:zodiacName" --->
# endpoint = "zodiac_compatibility/aquarius"
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

# <--- Test du endpoint "compatibility/:sunSign/:risingSign/:partnerSunSign/:partnerRisingSign" --->
# endpoint = "compatibility/aquarius/gemini/gemini/scorpio"
# data = {}
# client = Client.new(user_id, api_key)
# data = client.get_response(endpoint, data)
# p data
