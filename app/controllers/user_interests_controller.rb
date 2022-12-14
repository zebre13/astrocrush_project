class UserInterestsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create destroy]
  def index
    UserInterest.all
  end

  def create
    user = User.find(params[:user])
    interest = Interest.find(params[:interest])

    @user_interest = UserInterest.new(user: user, interest: interest)
    @user_interest.save
  end

  def destroy
    user_interest = UserInterest.find(params[:id])
    user_interest.destroy
  end

end
