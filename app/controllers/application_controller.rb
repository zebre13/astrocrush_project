class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(
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
        :minimum_age,
        :maximum_age,
        :looking_for,
        :star_sign,
        :rising,
        :moon,
        :coordinates_updated_today,
        :timezone,
        :local_lat,
        :local_lon,
        hobbies: [],
        photos: []
      )
    end

    devise_parameter_sanitizer.permit(:account_update) do |u| u.permit(
      :username,
      :email,
      :password,
      :password_confirmation,
      :current_password,
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
      :minimum_age,
      :maximum_age,
      :star_sign,
      :rising,
      :utcoffset,
      :moon,
      :coordinates_updated_today,
      :timezone,
      :local_lat,
      :local_lon,
      :minimal_age,
      :maximum_age,
      :search_perimeter,
      hobbies: [],
      photos: []
    )
    end
  end

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end
end
