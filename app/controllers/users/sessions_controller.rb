# frozen_string_literal: true

require_relative '../../../app/services/astrology_api'

class Users::SessionsController < Devise::SessionsController
  # API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])
  # after_action :define_coordinates, only: %i[new]

  # Mettre a jour les coordonées de l'utilisateur.

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
