class Users::RegistrationsController < Devise::RegistrationsController
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

    Astroprofil.new.profil(current_user)
  end

  def create_ten_affinities
    return unless user_signed_in?

    mates_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id).sample(10)
    mates_by_gender.each { |mate| affinities(current_user, mate) }
  end

  def affinities(user, mate)
    Affinities.new.partner_report(user, mate)
    Affinities.new.match_percentage(user, mate)
  end

  def ten_mates
    mates_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id).sample(10)
    return mates_by_gender
  end
  
  protected

  def update_resource(resource, params)
    if params[:password].present?
      updated = super
    else
      params.delete(:current_password)
      updated = resource.update_without_password(params)
    end
    if updated
      return updated
    end
  end
end
