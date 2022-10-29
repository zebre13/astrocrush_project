require_relative '../../../app/services/affinities'
require_relative '../../../app/services/astroprofil'
require_relative '../../../app/services/geocode'

class Users::RegistrationsController < Devise::RegistrationsController
  ASTROPROFIL = Astroprofil.new
  AFFINITIES = Affinities.new
  GEOCODE = Geocode.new

  after_action :create_astroprofil, only: %i[new create]
  after_action :create_ten_affinities, only: %i[new create]

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def create_astroprofil
    return unless user_signed_in?

    ASTROPROFIL.profil(current_user)
  end

  def create_ten_affinities
    return unless user_signed_in?

    ten_mates.each { |mate| affinities(current_user, mate) }
  end

  def affinities(user, mate)
    AFFINITIES.partner_report(user, mate)
    AFFINITIES.match_percentage(user, mats)
  end

  def ten_mates
    mates_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    return mates_by_gender.sample(10)
  end
end
