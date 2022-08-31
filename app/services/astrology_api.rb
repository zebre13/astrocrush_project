require 'net/http'
require 'json'
require 'date'
require 'time'

class AstrologyApi
  @@base_url = "http://json.astrologyapi.com/v1/" # Remettre https lorsqu'une solution aura été trouvée avec net/http

  def initialize(uid = nil, key = nil)
    @api_uid = uid
    @api_key = key
  end

  # Hash containing all data from an horoscope
  def horoscope(birth_date, birth_hour, latitude, longitude)
    endpoint = "western_horoscope"
    data = birth_data_set(birth_date, birth_hour, latitude, longitude)
    return get_response(endpoint, data)
  end

  # Hash providing sign and house for each one of the 10 planets
  def planets_location(birth_date, birth_hour, latitude, longitude)
    horo_elements = horoscope(birth_date, birth_hour, latitude, longitude)['planets']
    planets = { Sun: {}, Moon: {}, Mars: {}, Mercury: {}, Jupiter: {}, Venus: {}, Saturn: {}, Uranus: {}, Neptune: {}, Pluto: {} }
    planets.each_key do |key|
      horo_elements.each do |element|
        planets[key] = { sign: element['sign'], house: element['house'] } if element['name'] == key.to_s
      end
    end
    return planets
  end

  # URL for natal wheel chart in svg format
  def wheel_chart(birth_date, birth_hour, latitude, longitude, planet_icon_color, inner_circle_background, sign_icon_color, sign_background)
    endpoint = "natal_wheel_chart"
    design_params = {
      planet_icon_color: planet_icon_color,
      inner_circle_background: inner_circle_background,
      sign_icon_color: sign_icon_color,
      sign_background: sign_background
    }
    data = birth_data_set(birth_date, birth_hour, latitude, longitude).merge(design_params)
    return get_response(endpoint, data)['chart_url']
  end

  # Personality report based on a user's birth data
  def personality_report(birth_date, birth_hour, latitude, longitude)
    endpoint = "personality_report/tropical"
    data = birth_data_set(birth_date, birth_hour, latitude, longitude)
    return get_response(endpoint, data)['report']
  end

  # Romantic personality report based on a user's birth data
  def romantic_personality_report(birth_date, birth_hour, latitude, longitude)
    endpoint = "romantic_personality_report/tropical"
    data = birth_data_set(birth_date, birth_hour, latitude, longitude)
    return get_response(endpoint, data)['report']
  end

  # Daily horoscope for a given sign
  def daily_horoscope(user_sign)
    endpoint = "horoscope_prediction/daily/#{user_sign}"
    return get_response(endpoint, {})['prediction']
  end

  # General sign report
  def sign_report(birth_date, birth_hour, latitude, longitude, planet)
    endpoint = "general_sign_report/tropical/#{planet.upcase}"
    data = birth_data_set(birth_date, birth_hour, latitude, longitude)
    return get_response(endpoint, data)
  end

  # Sign compatibility
  def zodiac_compatibility(user_sign)
    endpoint = "zodiac_compatibility/#{user_sign}"
    return get_response(endpoint, {})
  end

  # Affinity percentage between a user (m) and and mate (f)
  def match_percentage(m_birth_date, m_birth_hour, m_latitude, m_longitude, f_birth_date, f_birth_hour, f_latitude, f_longitude)
    endpoint = "match_percentage"
    m_data = m_birth_data_set(m_birth_date, m_birth_hour, m_latitude, m_longitude)
    f_data = f_birth_data_set(f_birth_date, f_birth_hour, f_latitude, f_longitude)
    data = m_data.merge(f_data)
    return get_response(endpoint, data)['match_percentage']
  end

  # Love compatibility report for relationship between primary user (p) and secondary mate (s)
  def love_compatibility_report(p_birth_date, p_birth_hour, p_city, p_country_code, s_birth_date, s_birth_hour, s_city, s_country_code)
    endpoint = "love_compatibility_report/tropical"
    p_data = p_birth_data_set(p_birth_date, p_birth_hour, p_city, p_country_code)
    s_data = s_birth_data_set(s_birth_date, s_birth_hour, s_city, s_country_code)
    data = p_data.merge(s_data)
    return get_response(endpoint, data)['love_report']
  end

  # Partner report for relationship between you and match
  def partner_report(you_birth_date, you_gender, match_birth_date, match_gender, match_name)
    endpoint = "partner_report"
    you_data = you_data_set(you_birth_date, you_gender)
    match_data = match_data_set(match_birth_date, match_gender, match_name)
    data = you_data.merge(match_data)
    return get_response(endpoint, data)
  end

  # Get response from API
  def get_response(endpoint, data)
    url = URI.parse(@@base_url + endpoint)
    req = Net::HTTP::Post.new(url)
    req.basic_auth @api_uid, @api_key
    req.set_form_data(data)
    resp = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
    JSON.parse(resp.body)
  end

  # Get coordinates (lat/lon) for a given city name (ex: "Paris") and country code (ex: "FR")
  def city_coord(latitude, longitude)
    return { lat: latitude, lon: longitude }
  end

  # Get coordinates (lat/lon) for a given city name (ex: "Paris") and country code (ex: "FR")
  # Utilisée pour retrouver lat et lon d'une ville dans la seed
  def city_coordinates(city, country_code)
    endpoint = "geo_details"
    data = { place: city, maxRows: 6 }
    cities = get_response(endpoint, data)
    city = cities['geonames'].select { |item| item['country_code'] == country_code.upcase }
    return { lat: city.first['latitude'], lon: city.first['longitude'] }
  end

  # Get timezone code given coordinates (lat/lon) and date ("dd/mm/yyyy")
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

  # Hash with formatted birth data given birth data
  def birth_data_set(birth_date, birth_hour, latitude, longitude)
    coord = city_coord(latitude, longitude)
    tzone = time_zone(coord[:lat], coord[:lon], birth_date)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    birth_hour = birth_hour.is_a?(String) ? Time.parse(birth_hour) : birth_hour
    {
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

  # Hash with formatted birth data given birth data for the user in match making method
  def m_birth_data_set(birth_date, birth_hour, latitude, longitude)
    coord = city_coord(latitude, longitude)
    tzone = time_zone(coord[:lat], coord[:lon], birth_date)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    birth_hour = birth_hour.is_a?(String) ? Time.parse(birth_hour) : birth_hour
    {
      m_day: birth_date.day,
      m_month: birth_date.month,
      m_year: birth_date.year,
      m_hour: birth_hour.hour,
      m_min: birth_hour.min,
      m_lat: coord[:lat],
      m_lon: coord[:lon],
      m_tzone: tzone
    }
  end

  # Hash with formatted birth data given birth data for the mate in match making method
  def f_birth_data_set(birth_date, birth_hour, latitude, longitude)
    coord = city_coord(latitude, longitude)
    tzone = time_zone(coord[:lat], coord[:lon], birth_date)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    birth_hour = birth_hour.is_a?(String) ? Time.parse(birth_hour) : birth_hour
    {
      f_day: birth_date.day,
      f_month: birth_date.month,
      f_year: birth_date.year,
      f_hour: birth_hour.hour,
      f_min: birth_hour.min,
      f_lat: coord[:lat],
      f_lon: coord[:lon],
      f_tzone: tzone
    }
  end

  # Hash with formatted birth data given birth data for the user in match making method
  def p_birth_data_set(birth_date, birth_hour, latitude, longitude)
    coord = city_coord(latitude, longitude)
    tzone = time_zone(coord[:lat], coord[:lon], birth_date)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    birth_hour = birth_hour.is_a?(String) ? Time.parse(birth_hour) : birth_hour
    {
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

  # Hash with formatted birth data given birth data for the mate in match making method
  def s_birth_data_set(birth_date, birth_hour, latitude, longitude)
    coord = city_coord(latitude, longitude)
    tzone = time_zone(coord[:lat], coord[:lon], birth_date)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    birth_hour = birth_hour.is_a?(String) ? Time.parse(birth_hour) : birth_hour
    {
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

  # Hash with formatted data for partner report method (you)
  def you_data_set(birth_date, gender)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    gender == 1 ? string_gender = 'male' : string_gender = 'female'
    {
      you_date: birth_date.day,
      you_month: birth_date.month,
      you_year: birth_date.year,
      you_gender: string_gender
    }
  end

  # Hash with formatted data for partner report method (match)
  def match_data_set(birth_date, gender, username)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    gender == 1 ? string_gender = 'male' : string_gender = 'female'
    {
      match_date: birth_date.day,
      match_month: birth_date.month,
      match_year: birth_date.year,
      match_gender: string_gender,
      match_name: username
    }
  end
end

