# frozen_string_literal: true
require 'pry-byebug'

class Users::RegistrationsController < Devise::RegistrationsController
  after_action :new_user_api_calls, only: [:create]

  def new_user_api_calls
    return unless user_signed_in?
    api_uid = ENV["API_UID"]
    api_key = ENV["API_KEY"]

    horo_elements = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"]).horoscope(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f)
    current_user.sign = horo_elements['planets'].first['sign']
    current_user.rising = horo_elements['houses'].first['sign']
    current_user.moon = horo_elements['planets'][1]['sign']
    planets = { Sun: {}, Moon: {}, Mars: {}, Mercury: {}, Jupiter: {}, Venus: {}, Saturn: {}, Uranus: {}, Neptune: {}, Pluto: {} }
    planets.each_key do |key|
      horo_elements['planets'].each do |element|
        planets[key] = { sign: element['sign'], house: element['house'] } if element['name'] == key.to_s
      end
    end
    current_user.planets = planets
    current_user.wheel_chart = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"]).wheel_chart(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f, "#2E3A59", "#ffffff", "#ffffff", "#2E3A59")
    current_user.personality_report = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"]).personality_report(current_user.birth_date, current_user.birth_hour, current_user.latitude.to_f, current_user.longitude.to_f)

    # current_user.photos.each do |photo|
    #   current_user.photos.attach(io: photo, filename: current_user.username, content_type: 'jpg')
    # end
    p "création des signes planetes etc OK"

    # Selection des personnes correspondant aux critères de recherche de ce nouvel user
    potential_mates = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    p "potential mates ok"
    score_collection = {}
    score_collection_of_mate = {}
    # partner_report_collection = {}
    sun_report_collection = {}

    # Ajout etienne
    current_user.affinity_scores = {}
    current_user.partner_reports = {}
    current_user.mate_sun_reports = {}
    # Calcul du score de match avec 10 potentiels matchs
    potential_mates.sample(10).each do |mate|
      if mate.gender == 2
        mate_score = AstrologyApi.new(api_uid, api_key).match_percentage(
          current_user.birth_date,
          current_user.birth_hour,
          current_user.latitude.to_f,
          current_user.longitude.to_f,
          mate.birth_date,
          mate.birth_hour,
          mate.latitude.to_f,
          mate.longitude.to_f
        )
        # Stocker le score de match chez le current_user avec son mate
        current_user.affinity_scores.store(mate.id, mate_score)
        current_user.save

        # Stocker dans le affinity_score du mate le score de match. TROUVER COMMENT SAUVER
        other_user = User.find(mate.id)
        other_user.affinity_scores.store(current_user.id, mate_score)
        other_user.save

      else
        mate_score = AstrologyApi.new(api_uid, api_key).match_percentage(
          mate.birth_date,
          mate.birth_hour,
          mate.latitude.to_f,
          mate.longitude.to_f,
          current_user.birth_date,
          current_user.birth_hour,
          current_user.latitude.to_f,
          current_user.longitude.to_f
        )
        p "Score match ok"
        # Stocker le score de match chez le current_user avec son mate
        current_user.affinity_scores.store(mate.id, mate_score)
        current_user.save

        # Stocker dans le affinity_score du mate le score de match. TROUVER COMMENT SAUVER
        other_user = User.find(mate.id)
        other_user.affinity_scores.store(current_user.id, mate_score)
        other_user.save

      end
      # Call api pour obtenir les textes descriptifs
      mate_partner_report = AstrologyApi.new(api_uid, api_key).partner_report(
        current_user.birth_date,
        current_user.gender,
        mate.birth_date,
        mate.gender,
        mate.username
      )
      current_user.partner_reports.store(mate.id, mate_partner_report)
      current_user.save
      # On stocke le partner report aussi chez l'utilisateur d'en face, le mate
      other_user = User.find(mate.id)
      other_user.partner_reports.store(current_user.id, mate_partner_report)
      other_user.save!

      # Descriptif du signe du mate stocké chez le current user
      mate_sun_report = AstrologyApi.new(api_uid, api_key).sign_report(
        mate.birth_date,
        mate.birth_hour,
        mate.latitude.to_f,
        mate.longitude.to_f,
        'sun'
      )
      current_user.mate_sun_reports.store(mate.id, mate_sun_report)
      current_user.save

      # Descriptif du signe du current_user stocké chez le mate
      my_sun_report = AstrologyApi.new(api_uid, api_key).sign_report(
        current_user.birth_date,
        current_user.birth_hour,
        current_user.latitude.to_f,
        current_user.longitude.to_f,
        'sun'
      )
      other_user = User.find(mate.id)
      other_user.mate_sun_reports.store(current_user.id, my_sun_report)
      other_user.save!
    end

    # ordered_score_collection = score_collection.sort_by { |_id, score| score }
    # current_user.affinity_scores = ordered_score_collection.reverse.to_h
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
