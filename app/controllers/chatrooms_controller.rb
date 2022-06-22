class ChatroomsController < ApplicationController
  
  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
    @match = Match.new
  end
end
