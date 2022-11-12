class AfterSignupController < ApplicationController
  include Wicked::Wizard
  # after_action :create_ten_affinities, only: %i[update] if
  # after_action :create_astroprofil, only: %i[update]
  steps :onboarding_birth, :onboarding_profile, :find_friends, :edit_password, :edit_infos

  def show
    @user = current_user
    case step
    when :onboarding_birth
      # @friends = @user.find_friends
    end
    render_wizard
  end

  def update
    case step
    when :onboarding_birth
      current_user.update(user_params("onboarding_birth"))
      create_ten_affinities
      create_astroprofil
    when :onboarding_profil
      current_user.update(user_params("onboarding_profil"))
    when :edit_password
      current_user.update(user_params("edit_password"))
    when :edit_infos
      current_user.update(user_params("edit_infos"))
    end
    sign_in(current_user, bypass_sign_in: true) # needed for devise
    render_wizard current_user
  end

  private

  def user_params(step)
  	permitted_attributes = case step
    when "onboarding_birth"
      [:birth_date, :birth_hour, :birth_location, :latitude, :longitude, :gender, :looking_for, :country, :city, :utcoffset]
    when "onboarding_profil"
      [:description, :hobbies, :maximum_age, :minimal_age, :search_perimeter, photos:[]]
    when "edit_password"
      [:password, :password_confirmation, :current_password]
    when "edit_infos"
      [:username, :description, :hobbies, :maximum_age, :minimal_age, :looking_for, :search_perimeter, photos:[]]
    end

  	params.require(:user).permit(permitted_attributes).merge(form_step: step)
  end

  # def birth_params
  #   params.require(:user)
  #         .permit(:birth_date, :birth_hour, :birth_location, :latitude, :longitude, :gender, :looking_for)
  # end

  # def profile_params
  #   params.require(:user)
  #         .permit(:description, :hobbies, :maximum_age, :minimal_age, :search_perimeter, photos:[])
  # end

  # def password_params
  #   params.require(:user)
  #         .permit(:password, :password_confirmation, :current_password)
  # end

  # def infos_params
  #   params.require(:user)
  #         .permit(:username, :description, :hobbies, :maximum_age, :minimal_age, :looking_for, :search_perimeter, photos:[])
  # end

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
end
