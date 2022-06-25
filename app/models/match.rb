class Match < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom
  belongs_to :mate, :foreign_key => :mate_id, :class_name => 'User'

  # validates :status, presence: true
  # validates :score, presence: true, uniqueness: true

  enum status: [ :pending, :accepted, :denied ]

  def mate_for(person)
    # user is the user_id of the match being considered
    # person is the user (current_user or not) for which we want to know the mate
    user == person ? mate : user
  end
end
