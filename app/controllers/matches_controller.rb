class MatchesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    # afficher mes match
    # @matches = Match.where(user_id: current_user.id).where.not(status: 0)
    @matches = current_user.matches.where(status: 'accepted').order("chatroom_id DESC")
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

  def destroy
  #   @matches = current_user.matches.where(status: 'accepted')
  #   @matches = Match.where(user_id: current_user.id).where.not(status: 0)
  # @matches.each do |match|
    @match = Match.find(params[:id])
    @match.destroy
    # authorize @match
      # if reponse == :delete
      #   flash[:success] = "are you sure you want to destroy."
            #  if click == "yes"
      #         flash[:success] = "you have successfully destroyed."
              redirect_to '/matches_path', :notice => "Your match has been deleted"
      #       else
      #         redirect_to '/matches_path' notice: ""
      #       end
      # end
  end
end
