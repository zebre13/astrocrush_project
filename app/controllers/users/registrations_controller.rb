require_relative '../../../app/services/affinities'
require_relative '../../../app/services/astroprofil'
require_relative '../../../app/services/geocode'


class Users::RegistrationsController < Devise::RegistrationsController
  ASTROPROFIL = Astroprofil.new
  AFFINITIES = Affinities.new
  GEOCODE = Geocode.new
  after_action :new_user_api_calls, only: [:create]

  def new_user_api_calls
    return unless user_signed_in?

    ASTROPROFIL.profil
    affinities(ten_mates)
    set_coordinates
  end

  private

  def set_coordinates
    current_user.local_lat = GEOCODE.set_latitude
    current_user.local_lon = GEOCODE.set_longitude
  end

  def afinities(mates)
    AFFINITIES.partner_report(mates)
    AFFINITIES.sun_reports(mates)
    AFFINITIES.match_percentage(mates)
  end

  ###

  def ten_mates
    mates_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    return mates_by_gender.sample(10)
  end
end
