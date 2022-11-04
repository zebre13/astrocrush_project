class Astroprofil
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])

  def profil(user)
    user.horoscope_data = API_CALL.horoscope(user.birth_date, user.birth_hour, user.latitude.to_f, user.longitude.to_f)
    user.sign = user.horoscope_data['planets'].first['sign']
    user.rising = user.horoscope_data['houses'].first['sign']
    user.moon = user.horoscope_data['planets'][1]['sign']
    user.wheel_chart = API_CALL.wheel_chart(user.birth_date, user.birth_hour, user.latitude.to_f, user.longitude.to_f, "#2E3A59", "#ffffff", "#ffffff", "#2E3A59")
    user.timezone = API_CALL.time_zone(user.latitude.to_f, user.longitude.to_f, user.birth_date)
    user.save!
  end
end
