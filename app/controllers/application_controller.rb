class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(
        :username,
        :email,
        :password,
        :password_confirmation,
        :description,
        :birth_date,
        :birth_hour,
        :country,
        :city,
        :utcoffset,
        :birth_location,
        :gender,
        :search_perimeter,
        :latitude,
        :longitude,
        :looking_for,
        :star_sign,
        :rising,
        :moon,
        :timezone,
        hobbies: [],
        photos: []
      )
    }
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(
        :username,
        :email,
        :password,
        :password_confirmation,
        :description,
        :birth_date,
        :birth_hour,
        :country,
        :city,
        :search_perimeter,
        :birth_location,
        :gender,
        :latitude,
        :longitude,
        :looking_for,
        :star_sign,
        :rising,
        :utcoffset,
        :moon,
        :timezone,
        hobbies: [],
        photos: [],
        )}
  end

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end
end
