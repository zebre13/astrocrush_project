# frozen_string_literal: true
require_relative '../../../app/services/astrology_api.rb'

class Users::SessionsController < Devise::SessionsController
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])
  # à chaque connection lancer la fonction

  # after_action :calcul_ten_scores, only: [:new]

  # récupérer les local_lat et local_lon du current_user en fonction de l'adresse ip
  # mettre à jour les préférences utilisateurs
  # virer les users avec un affinity_score déjà présent
  # calculer 10 nouveaux scores à partir des users obtenus

  # def calcul_ten_scores
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
