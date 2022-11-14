class AfterSignupController < ApplicationController
  include Wicked::Wizard
  # after_action :create_ten_affinities, only: %i[update] if
  # after_action :create_astroprofil, only: %i[update]
  steps :onboarding_birth, :onboarding_profile

  def show
    @user = current_user
    render_wizard
  end

  def update
    @user = current_user
    case step
    when :onboarding_birth
      @user.update(user_params("onboarding_birth"))
      helpers.create_affinities(10)
      helpers.create_astroprofil
    when :onboarding_profile
      @user.update(user_params("onboarding_profile"))
      finish_wizard_path
    end
    sign_in(@user, bypass_sign_in: true) # needed for devise
    render_wizard @user
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
                             [:username, :description, photos:[], hobbies:[]]
                           end
    params.require(:user).permit(permitted_attributes).merge(form_step: step)
  end
end
