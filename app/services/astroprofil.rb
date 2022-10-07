require_relative '../../../app/services/astrology_api'

class Astroprofil
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])

  def profil
    horoscope = API_CALL.horoscope(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f)
    current_user.sign = horoscope['planets'].first['sign']
    current_user.rising = horoscope['houses'].first['sign']
    current_user.moon = horoscope['planets'][1]['sign']
    current_user.planets = planets(horoscope)
    current_user.wheel_chart = API_CALL.wheel_chart(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f, "#2E3A59", "#ffffff", "#ffffff", "#2E3A59")
    current_user.personality_report = API_CALL.personality_report(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f)
    current_user.timezone = API_CALL.time_zone(current_user.latitude.to_f, current_user.longitude.to_f, current_user.birth_date)
  end

  private

  def planets(horoscope)
    planets = { Sun: {}, Moon: {}, Mars: {}, Mercury: {}, Jupiter: {}, Venus: {}, Saturn: {}, Uranus: {}, Neptune: {}, Pluto: {} }
    planets.each_key do |key|
      horoscope['planets'].each do |element|
        planets[key] = { sign: element['sign'], house: element['house'] } if element['name'] == key.to_s
      end
    end
  end

end
