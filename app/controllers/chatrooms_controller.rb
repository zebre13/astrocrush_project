class ChatroomsController < ApplicationController

  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
    @match = Match.new
    @chatroom.messages.each do |message|
      message.seen = true
    end
  end
end
