class Astroprofil
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])

  def self.profil(user)
    horoscope = API_CALL.horoscope(user.birth_date, user.birth_hour, user.latitude.to_f, user.longitude.to_f)
    user.sign = horoscope['planets'].first['sign']
    user.rising = horoscope['houses'].first['sign']
    user.moon = horoscope['planets'][1]['sign']
    user.planets = planets(horoscope)
    user.wheel_chart = API_CALL.wheel_chart(user.birth_date, user.birth_hour, user.latitude.to_f, user.longitude.to_f, "#2E3A59", "#ffffff", "#ffffff", "#2E3A59")
    user.personality_report = API_CALL.personality_report(user.birth_date, user.birth_hour, user.latitude.to_f, user.longitude.to_f)
    user.timezone = API_CALL.time_zone(user.latitude.to_f, user.longitude.to_f, user.birth_date)
    user.save!
  end


  def self.planets(horoscope)
    planets = { Sun: {}, Moon: {}, Mars: {}, Mercury: {}, Jupiter: {}, Venus: {}, Saturn: {}, Uranus: {}, Neptune: {}, Pluto: {} }
    planets.each_key do |key|
      horoscope['planets'].each do |element|
        planets[key] = { sign: element['sign'], house: element['house'] } if element['name'] == key.to_s
      end
    end
  end

end
