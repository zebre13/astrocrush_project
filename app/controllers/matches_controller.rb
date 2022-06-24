class MatchesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :create_denied_match]

  def index
    # afficher mes match
    # @matches = Match.where(user_id: current_user.id).where.not(status: 0)
    @matches = current_user.matches.where(status: 'accepted').order("chatroom_id DESC")
  end

  def create
    @mate = User.find(params[:id])
    if Match.find_by(user: @mate, mate: current_user) || Match.find_by(mate: @mate, user: current_user)
      @match = Match.find_by(user: @mate, mate: current_user) || Match.find_by(mate: @mate, user: current_user)
      @match.update(status: 1)
      p "You got a new match!"
      p render_to_string partial: "matches/success"
    else
      # sinon si personne de nous deux ne s'est encore liké:
      @match = Match.new
      @match.mate = @mate
      @match = Match.new(mate: @mate, user: current_user, status: 0)
      @chatroom = Chatroom.create!
      @match.chatroom = @chatroom
      @match.save!
      p "Match created with status pending successfully"
    end
    respond_to do |format|
      html_content = render_to_string partial: "matches/success"
      format.json { render json: { match: @match, content: html_content } }
      format.html { render "matches/success" }
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy
    flash[:success] = "you have successfully destroyed."
    redirect_to '/matches_path', :notice => "Your match has been deleted"
  # def destroy
  #   @matches = Match.where(user_id: current_user.id).where.not(status: 0)
  # @mattches.each do |match|
  # match.destroy
  # end
  # @match.mate.destroy
  end

  def match_data
    {
      inserted_item: render_to_string(partial: 'matches/success.html')
    }
  end
end
