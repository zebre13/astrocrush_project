class UsersController < ApplicationController

  def index
    # Faire en sorte que l'index proposé corresponde a ce que l'utilisateur recherche
    @matches = current_user.matches

    @users_by_gender = User.where(gender: current_user.looking_for)
    @users = @users_by_gender.reject do |user|
      current_user.matches.pluck(:mate_id).include?(user.id)
    end
  end

  def show
    @mate = User.find(params[:id])
  end
end
