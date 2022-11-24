class Affinity < ActiveRecord::Base
  belongs_to :user
  belongs_to :mate, foreign_key: :mate_id, class_name: 'User'
  has_one :report, dependent: :destroy

  validates :score, presence: true
  validates :report, presence: true
end
