class UserInterestsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  def index
    UserInterest.all
  end

  def create
    user = User.find(params[:user])
    interest = Interest.find(params[:interest])

    @user_interest = UserInterest.new(user: user, interest: interest)
    @user_interest.save
  end

end
