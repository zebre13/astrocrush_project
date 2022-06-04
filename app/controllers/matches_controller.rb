class MatchesController < ApplicationController
  def create
    @match = Match.new
    @match.mate = User.find(params[:id])
    @match.user = current_user
    @match.status = "pending"
  end
end
