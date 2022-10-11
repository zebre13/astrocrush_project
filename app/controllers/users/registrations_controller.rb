require_relative '../../../app/services/affinities'
require_relative '../../../app/services/astroprofil'
require_relative '../../../app/services/geocode'

class Users::RegistrationsController < Devise::RegistrationsController
  ASTROPROFIL = Astroprofil.new
  AFFINITIES = Affinities.new
  GEOCODE = Geocode.new
  after_action :new_user_api_calls, only: %i[new create]

  def new_user_api_calls
    return unless user_signed_in?

    user = current_user
    ASTROPROFIL.profil(user)
    GEOCODE.coordinates(user, user.current_sign_in_ip)
    mates = ten_mates
    affinities(user, mates)
    user.save!
  end

  private

  def affinities(user, mates)
    AFFINITIES.partner_report(user, mates)
    AFFINITIES.sign_report(user, mates)
    AFFINITIES.match_percentage(user, mates)
    user.save!
  end

  def ten_mates
    mates_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    return mates_by_gender.sample(10)
  end
end
