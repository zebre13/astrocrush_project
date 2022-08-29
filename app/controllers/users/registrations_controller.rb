# frozen_string_literal: true
require 'pry-byebug'

class Users::RegistrationsController < Devise::RegistrationsController
  after_action :new_user_api_calls, only: [:create]

  def new_user_api_calls
    return unless user_signed_in?
    api_uid = ENV["API_UID"]
    api_key = ENV["API_KEY"]

    # Transformer "Barcelona, Spain" en "Barcelona" par exemple. Garder que la ville
    current_user.city = current_user.birth_location.split(' ')[0].tr(',', '')


    horo_elements = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"]).horoscope(current_user.birth_date, current_user.birth_hour, current_user.city, current_user.country)
    # horo_elements = API_CALL.horoscope(current_user.birth_date, current_user.birth_hour, current_user.birth_location, current_user.country)
    current_user.sign = horo_elements['planets'].first['sign']
    current_user.rising = horo_elements['houses'].first['sign']
    current_user.moon = horo_elements['planets'][1]['sign']
    current_user.planets = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"]).planets_location(current_user.birth_date, current_user.birth_hour, current_user.city, current_user.country)
    current_user.wheel_chart = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"]).wheel_chart(current_user.birth_date, current_user.birth_hour, current_user.city, current_user.country, "#2E3A59", "#ffffff", "#ffffff", "#2E3A59")
    current_user.personality_report = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"]).personality_report(current_user.birth_date, current_user.birth_hour, current_user.city, current_user.country)


    # current_user.photos.each do |photo|
    #   current_user.photos.attach(io: photo, filename: current_user.username, content_type: 'jpg')
    # end
    p "création des signes planetes etc OK"

    # Selection des personnes correspondant aux critères de recherche de ce nouvel user
    potential_mates = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    p "potential mates ok"
    score_collection = {}
    partner_report_collection = {}
    sun_report_collection = {}

    # Calcul du score de match avec chaque potential mate
    potential_mates.each do |mate|
      if mate.gender == 2
        mate_score = AstrologyApi.new(api_uid, api_key).match_percentage(
          current_user.birth_date,
          current_user.birth_hour,
          current_user.city,
          current_user.country,
          mate.birth_date,
          mate.birth_hour,
          mate.city,
          mate.country
        )
        score_collection.store(mate.id, mate_score)
      else
        mate_score = AstrologyApi.new(api_uid, api_key).match_percentage(
          mate.birth_date,
          mate.birth_hour,
          mate.city,
          mate.country,
          current_user.birth_date,
          current_user.birth_hour,
          current_user.city,
          current_user.country
        )
        p "Score match ok"
        score_collection.store(mate.id, mate_score)
      end
      # Call api pour obtenir les textes descriptifs
      mate_partner_report = AstrologyApi.new(api_uid, api_key).partner_report(
        current_user.birth_date,
        current_user.gender,
        mate.birth_date,
        mate.gender,
        mate.username
      )
      partner_report_collection.store(mate.id, mate_partner_report)

      # Descriptif de ton signe
      mate_sun_report = AstrologyApi.new(api_uid, api_key).sign_report(
        mate.birth_date,
        mate.birth_hour,
        mate.city,
        mate.country,
        'sun'
      )
      sun_report_collection.store(mate.id, mate_sun_report)
    end

    ordered_score_collection = score_collection.sort_by { |_id, score| score }
    current_user.affinity_scores = ordered_score_collection.reverse.to_h
    current_user.partner_reports = partner_report_collection
    current_user.mate_sun_reports = sun_report_collection
    current_user.save!
  end
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
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
