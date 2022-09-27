# frozen_string_literal: true
require_relative '../../../app/services/astrology_api.rb'

class Users::SessionsController < Devise::SessionsController
  API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])
  # after_action :define_coordinates, only: %i[new create] (Faut trouver le timing mais on peut pas le faire à chaque session, il faut que ca soit fait quotidiennement sinon l'user se déco reco sans cesse pour rafraichir ses mates)

  # Mettre a jour les coordonées de l'utilisateur.

  private



  def define_coordinates
    ip = request.remote_ip
    current_user.local_lat = Geocoder.search(request.remote_ip).first.coordinates[0]
    current_user.local_lon = Geocoder.search(ip).first.coordinates[1]
  end



  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
