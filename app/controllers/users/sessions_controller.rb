# frozen_string_literal: true

require_relative '../../../app/services/astrology_api'

class Users::SessionsController < Devise::SessionsController
  # API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])
  # after_action :define_coordinates, only: %i[new create]

  # Mettre a jour les coordonées de l'utilisateur.

  def new
    current_user.local_lat = define_local_lat
    current_user.local_lon = define_local_lon
  end

  private


  def define_local_lat
    Geocoder.search(request.remote_ip).first.coordinates[0]
  end

  def define_local_lon
    Geocoder.search(request.remote_ip).first.coordinates[1]
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
