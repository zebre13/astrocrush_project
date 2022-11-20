class AfterSignupController < ApplicationController
  include Wicked::Wizard
  # after_action :create_ten_affinities, only: %i[update] if
  # after_action :create_astroprofil, only: %i[update]
  steps :onboarding_birth, :onboarding_profile, :onboarding_interests

  def show
    @user = current_user
    @interests = Interest.all
    render_wizard
  end

  def update
    case step
    when :onboarding_birth
      current_user.update(user_params("onboarding_birth"))
      helpers.create_affinities(10)
      helpers.create_astroprofil
    when :onboarding_profile
      current_user.update(user_params("onboarding_profile"))
      finish_wizard_path
    when :onboarding_interests
      current_user.interests.update(user_params("onboarding_interests"))
      finish_wizard_path
    end
    sign_in(current_user, bypass_sign_in: true) # needed for devise
    render_wizard current_user
  end

  def finish_wizard_path
    root_path
  end

  private

  def user_params(step)
    permitted_attributes = case step
                           when "onboarding_birth"
                             %i[birth_date birth_hour birth_location latitude longitude gender looking_for country city utcoffset]
                           when "onboarding_profile"
                             [:username, :description, photos:[]]
                           when "onboarding_interests"
                             [:interests]
                           end
    params.require(:user).permit(permitted_attributes).merge(form_step: step)
  end
end
