class Chatroom < ApplicationRecord
  has_many :messages
  has_many :matches

  def interlocutor_of(user)
    user == first_user ? second_user : first_user
  end

end
