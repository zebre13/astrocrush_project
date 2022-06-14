class MatchesController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:create, :create_denied_match]


  def index
    # afficher mes match
    # @matches = Match.where(user_id: current_user.id).where.not(status: 0)
    @matches = current_user.matches.where(status: 'accepted').order("chatroom_id DESC")
  end

  def create
    @mate = User.find(params[:id])
    # Faut dabord que je retrouve si la personne m'a liké, pour confirmer le potentiel match.
    if Match.find_by(user: @mate, mate: current_user) || Match.find_by(mate: @mate, user: current_user)
      p "FOOOOOOUND A MAAAAAAAAAAAAAAAAAAAATCH"
      @match = Match.find_by(user: @mate, mate: current_user) || Match.find_by(mate: @mate, user: current_user)
      p @match.id, @match.status
      p "this was match id"
      @match.update(status: 1)
      p @match.status
      p @match.id
      flash.alert = "Its a MAAAATCH"


    else
      # sinon si personne de nous deux ne s'est encore liké:
      @match = Match.new
      @match.mate = @mate
      @chatroom = Chatroom.create!
      @match.chatroom = @chatroom
      @match.save!
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy
    flash[:success] = "you have successfully destroyed."
    redirect_to '/matches_path', :notice => "Your match has been deleted"
  end
end
