class MatchesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :create_denied_match]
  def create_denied_match
    @mate = User.find(params[:id])
    @chatroom = Chatroom.create!
    @match = Match.create(user: current_user, mate: @mate, chatroom: @chatroom)
    if @match.update(status: 2)
      p "match created with status denied successfully"
    else
      p @match.errors.messages
    end
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
      @match = Match.new(mate: @mate, user: current_user, status: 0)
      # @match.mate = @mate
      @chatroom = Chatroom.create!
      @match.chatroom = @chatroom
      @match.save!
    end
  end


end
