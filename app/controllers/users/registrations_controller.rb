require_relative '../../../app/services/affinities'
require_relative '../../../app/services/astroprofil'
require_relative '../../../app/services/geocode'

class Users::RegistrationsController < Devise::RegistrationsController
  ASTROPROFIL = Astroprofil.new
  AFFINITIES = Affinities.new
  GEOCODE = Geocode.new

  after_action :create_astroprofil, only: %i[new create]
  after_action :create_affinities, only: %i[new create]

  private

  def create_astroprofil
    return unless user_signed_in?

    ASTROPROFIL.profil(current_user)
  end

  def create_affinities
    return unless user_signed_in?

    affinities(current_user, ten_mates)
  end

  def affinities(user, mates)
    AFFINITIES.partner_report(user, mates)
    AFFINITIES.sign_report(user, mates)
    AFFINITIES.match_percentage(user, mates)
  end

  def ten_mates
    mates_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    return mates_by_gender.sample(10)
  end
end
