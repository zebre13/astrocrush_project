class Users::ConfirmationsController < Devise::ConfirmationsController
  def new
    super
  end
    # resource.login = current_user.email if user_signed_in?
  end

  protected

  def after_resending_confirmation_instructions_path_for(resource_name)
    if user_signed_in?
      home_path
    else
      new_session_path(resource_name)
    end if is_navigational_format?
  end

  def after_confirmation_path_for(resource_name, resource)
    super(resource_name, resource)
  end

end
