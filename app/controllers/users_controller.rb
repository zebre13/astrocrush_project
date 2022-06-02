class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    current_user
    @mate = User.find(params[:id])
  end
end
