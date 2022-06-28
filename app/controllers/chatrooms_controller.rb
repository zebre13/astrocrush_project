class ChatroomsController < ApplicationController

  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
    @match = Match.new
    @chatroom.messages.each do |message|
      message.seen = true
    end
  end

  # Tuto messages a gauche et droite de Paul :
  # def index
  #   @chatrooms = current_user.chatrooms
  # end
  # def show
  # @chatroom = Chatroom.find(params[:id]) @message = Message.new
  # end
end
