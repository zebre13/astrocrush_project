# frozen_string_literal: true

require_relative '../../../app/services/astrology_api'

class Users::RegistrationsController < Devise::RegistrationsController
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])
  before_action :get_other_user, only: %i[partner_report my_sun_report mate_sun_report]
  after_action :new_user_api_calls, only: [:create]

  def new_user_api_calls
    return unless user_signed_in?

    current_user.sign = horoscope(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f)['planets'].first['sign']
    current_user.rising = horoscope(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f)['houses'].first['sign']
    current_user.moon = horoscope(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f)['planets'][1]['sign']
    current_user.wheel_chart = wheel_chart(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f)
    current_user.planets = planets(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f)
    current_user.personality_report = personality_report(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f)
    current_user.timezone = time_zone(current_user.latitude.to_f, current_user.longitude.to_f, current_user.birth_date)
    current_user.local_lat = define_local_lat
    current_user.local_lon = define_local_lon

    get_affinities
  end

  private

  def horoscope(birth_date, birth_hour, latitude, longitude)
    API_CALL.horoscope(birth_date, birth_hour, latitude, longitude)
  end

  def wheel_chart(birth_date, birth_hour, latitude, longitude)
    API_CALL.wheel_chart(birth_date, birth_hour, latitude, longitude, "#2E3A59", "#ffffff", "#ffffff", "#2E3A59")
  end

  def planets(birth_date, birth_hour, latitude, longitude)
    planets = { Sun: {}, Moon: {}, Mars: {}, Mercury: {}, Jupiter: {}, Venus: {}, Saturn: {}, Uranus: {}, Neptune: {}, Pluto: {} }
    planets.each_key do |key|
      horoscope(birth_date, birth_hour, latitude, longitude)['planets'].each do |element|
        planets[key] = { sign: element['sign'], house: element['house'] } if element['name'] == key.to_s
      end
    end
  end

  def personality_report(birth_date, birth_hour, latitude, longitude)
    API_CALL.personality_report(birth_date, birth_hour, latitude, longitude)
  end

  # sign_report

  # sign_compatbility

  def time_zone(lat, lon, birth_date)
    API_CALL.time_zone(lat, lon, birth_date)
  end

  def define_local_lat
    Geocoder.search(request.remote_ip).first.coordinates[0]
  end

  def define_local_lon
    Geocoder.search(request.remote_ip).first.coordinates[1]
  end

  def sun_report(birth_date, birth_hour, latitude, longitude)
    API_CALL.sign_report(birth_date, birth_hour, latitude, longitude, 'sun')
  end

  # calculated only on ten mates
  def ten_mates
    mates_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    return mates_by_gender.sample(10)
  end

  def get_affinities
    score_collection = {}
    partner_report_collection = {}
    sun_report_collection = {}
    
    ten_mates.each do |mate|

      if current_user.gender == mate.gender
        mate_score_one = API_CALL.match_percentage(current_user.birth_date, current_user.birth_hour, current_user.latitude, current_user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
        mate_score_two = API_CALL.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, current_user.birth_date, current_user.birth_hour, current_user.latitude, current_user.longitude)
        if mate_score_one > mate_score_two
          mate_score = mate_score_one
        else
          mate_score = mate_score_two
        end
      else
        if mate.gender == 2
          mate_score = API_CALL.match_percentage(current_user.birth_date, current_user.birth_hour, current_user.latitude, current_user.longitude, mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude)
        else
          mate_score = API_CALL.match_percentage(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude, current_user.birth_date, current_user.birth_hour, current_user.latitude, current_user.longitude)
        end
      end

      score_collection.store(mate.id, mate_score)

      mate_partner_report = API_CALL.partner_report(current_user.birth_date, current_user.gender, mate.birth_date, mate.gender, mate.username)
      partner_report_collection.store(mate.id, mate_partner_report)

      mate_sun_report = API_CALL.sign_report(mate.birth_date, mate.birth_hour, mate.latitude, mate.longitude,'sun')
      sun_report_collection.store(mate.id, mate_sun_report)
    end

    ordered_score_collection = score_collection.sort_by { |_id, score| score }
    current_user.affinity_scores = ordered_score_collection.reverse.to_h
    current_user.partner_reports = partner_report_collection
    current_user.mate_sun_reports = sun_report_collection
    current_user.save!
  end

  # def my_sun_report(birth_date, birth_hour, latitude, longitude)
  #   ten_mates.each do |mate|
  #     other_user = User.find(mate.id)
  #     other_user.mate_sun_reports.store(current_user.id, sun_report(birth_date, birth_hour, latitude, longitude))
  #     other_user.save!
  #   end
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
