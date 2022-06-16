class UsersController < ApplicationController
  require 'json'

  def index
    # Faire en sorte que l'index proposé corresponde a ce que l'utilisateur recherche
    @matches = current_user.matches

    @users_by_gender = User.where(gender: current_user.looking_for).where.not(id: current_user.id)
    # On rejette tous les users qui sont dans les matchs du current user.
    @users = @users_by_gender.reject do |user|
      Match.where("(user_id = ? AND status = 0) OR (mate_id = ? AND status IN (1, 2))", current_user.id, current_user.id).pluck(:mate_id, :user_id).flatten.include?(user.id)
      # Match.where("user_id = ? OR (mate_id = ? AND status IN ?)", current_user.id, current_user.id, [1, 2]).pluck(:mate_id, :user_id).flatten.include?(user.id)
    end
    p "THIS ISSSS THE ARRAY WE WANT TO BE EMPTYYYY"
    p @users
  end

  def show
    @mate = User.find(params[:id])
  end

  
end
