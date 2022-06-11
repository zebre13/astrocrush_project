class Match < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom
  belongs_to :mate, :foreign_key => :mate_id, :class_name => 'User'

  # validates :status, presence: true
  # validates :score, presence: true, uniqueness: true

  enum status: [ :pending, :accepted, :denied ]
end
