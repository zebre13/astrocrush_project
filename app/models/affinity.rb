class Affinity < ActiveRecord::Base
  belongs_to :user
  belongs_to :mate, foreign_key: :mate_id, class_name: 'User'

  validates :score, presence: true
end
