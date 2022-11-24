class Report < ApplicationRecord
  belongs_to :affinity

  validates :title, presence: true
  validates :msg, presence: true
  validates :tags, presence: true
end
