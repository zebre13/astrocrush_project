# frozen_string_literal: true



class Users::SessionsController < Devise::SessionsController
  # API_CALL = AstrologyApi.new(ENV["API_UID"], ENV["API_KEY"])
  # after_action :define_coordinates, only: %i[new]

  # protected
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
