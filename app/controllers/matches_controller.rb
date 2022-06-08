class MatchesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    # afficher mes match 
    # @match = Match.where(user_id: current_user, score: "accepted")
    @Matches.all
  end

  def create
    @mate = User.find(params[:id])

    # Match.find_or_create_by(name: 'Spartacus', rating: 4)
    # returns the first item or creates it and returns it.

    # Faut dabord que je retrouve si la personne m'a liké, pour confirmer le potentiel match.
    if Match.find_by(user: @mate, mate: current_user) || Match.find_by(mate: @mate, user: current_user)
      p "FOOOOOOUND A MAAAAAAAAAAAAAAAAAAAATCH"
      @match = Match.find_by(user: @mate, mate: current_user) || Match.find_by(mate: @mate, user: current_user)
      p @match.id, @match.status
      p "this was match id"
      if @match.update(status: 1)
        flash.alert = "Its a MAAAATCH"
      else
        flash.alert = "smth went wrong"
      end

    else
    # sinon si personne de nous deux ne s'est encore liké:
      @match = Match.new
      @match.mate = @mate
      @chatroom = Chatroom.create!
      @match.chatroom = @chatroom
      @match.user = current_user
      @match.status = 0
      @match.save!
    end
  end
end
