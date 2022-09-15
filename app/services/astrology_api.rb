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

  # URL of a natal wheel chart in svg format
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

  # Affinity percentage between a male user (m) and a female user (f)
  def match_percentage(m_birth_date, m_birth_hour, m_latitude, m_longitude, f_birth_date, f_birth_hour, f_latitude, f_longitude)
    endpoint = "match_percentage"
    m_data = m_birth_data_set(m_birth_date, m_birth_hour, m_latitude, m_longitude)
    f_data = f_birth_data_set(f_birth_date, f_birth_hour, f_latitude, f_longitude)
    data = m_data.merge(f_data)
    return get_response(endpoint, data)['match_percentage']
  end

  # Partner report for relationship between user and mate
  def partner_report(user_birth_date, user_gender, mate_birth_date, mate_gender, mate_name)
    endpoint = "partner_report"
    user_data = user_data_set(user_birth_date, user_gender)
    mate_data = mate_data_set(mate_birth_date, mate_gender, mate_name)
    data = user_data.merge(mate_data)
    return get_response(endpoint, data)
  end

  def time_zone(lat, lon, birth_date)
    endpoint = "timezone_with_dst"
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    data = {
      latitude: lat.to_f,
      longitude: lon.to_f,
      date: birth_date.strftime("%-m-%-d-%Y")
    }
    info = get_response(endpoint, data)
    return info['timezone']
  end
  
  private

  # Get response from API given endpoint and data
  def get_response(endpoint, data)
    url = URI.parse(@@base_url + endpoint)
    req = Net::HTTP::Post.new(url)
    req.basic_auth @api_uid, @api_key
    req.set_form_data(data)
    resp = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
    JSON.parse(resp.body)
  end

  # Get timezone offset with daylight saving time (in hours) given geo coordinates (lat/lon) and date ("dd/mm/yyyy")

  # Hash with formatted birth data used in the "horoscope", "sign_report", "personality report" and "wheel_chart" methods
  def birth_data_set(birth_date, birth_hour, latitude, longitude)
    tzone = time_zone(latitude, longitude, birth_date)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    birth_hour = birth_hour.is_a?(String) ? Time.parse(birth_hour) : birth_hour
    {
      day: birth_date.day,
      month: birth_date.month,
      year: birth_date.year,
      hour: birth_hour.hour,
      min: birth_hour.min,
      lat: latitude,
      lon: longitude,
      tzone: tzone
    }
  end

  # Hash with formatted MALE (m) USER's birth data used in the "match_percentage" method
  def m_birth_data_set(birth_date, birth_hour, latitude, longitude)
    tzone = time_zone(latitude, longitude, birth_date)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    birth_hour = birth_hour.is_a?(String) ? Time.parse(birth_hour) : birth_hour
    {
      m_day: birth_date.day,
      m_month: birth_date.month,
      m_year: birth_date.year,
      m_hour: birth_hour.hour,
      m_min: birth_hour.min,
      m_lat: latitude,
      m_lon: longitude,
      m_tzone: tzone
    }
  end

  # Hash with formatted FEMALE (f) USER's birth data used in the "match_percentage" method
  def f_birth_data_set(birth_date, birth_hour, latitude, longitude)
    tzone = time_zone(latitude, longitude, birth_date)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    birth_hour = birth_hour.is_a?(String) ? Time.parse(birth_hour) : birth_hour
    {
      f_day: birth_date.day,
      f_month: birth_date.month,
      f_year: birth_date.year,
      f_hour: birth_hour.hour,
      f_min: birth_hour.min,
      f_lat: latitude,
      f_lon: longitude,
      f_tzone: tzone
    }
  end

  # Hash with USER's formatted data used int the "partner_report" method
  def user_data_set(birth_date, gender)
    birth_date = birth_date.is_a?(String) ? Date.parse(birth_date) : birth_date
    gender == 1 ? string_gender = 'male' : string_gender = 'female'
    {
      you_date: birth_date.day,
      you_month: birth_date.month,
      you_year: birth_date.year,
      you_gender: string_gender
    }
  end

  # Hash with MATE's formatted data used in the "partner_report" method
  def mate_data_set(birth_date, gender, username)
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
