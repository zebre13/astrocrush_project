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

    ASTROPROFIL.profil(current_user)
    GEOCODE.coordinates(current_user, current_user.current_sign_in_ip)
    affinities(current_user, ten_mates)
  end

  private

  def afinities(user, mates)
    AFFINITIES.partner_report(user, mates)
    AFFINITIES.sun_reports(user, mates)
    AFFINITIES.match_percentage(user, mates)
  end

  def ten_mates
    mates_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    return mates_by_gender.sample(10)
  end
end
