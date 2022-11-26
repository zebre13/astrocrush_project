class Astroprofil
  def self.profil(user)
    user.horoscope_data = AstrologyApi.horoscope(user.birth_date, user.birth_hour, user.latitude.to_f, user.longitude.to_f)
    user.sign = user.horoscope_data['planets'].first['sign']
    user.rising = user.horoscope_data['houses'].first['sign']
    user.moon = user.horoscope_data['planets'][1]['sign']
    user.wheel_chart = AstrologyApi.wheel_chart(user.birth_date, user.birth_hour, user.latitude.to_f, user.longitude.to_f, "#2E3A59", "#ffffff", "#ffffff", "#2E3A59")
    user.timezone = AstrologyApi.time_zone(user.latitude.to_f, user.longitude.to_f, user.birth_date)
  end
end
