class Event < ApplicationRecord
  belongs_to :asset_sim
  validates :name, presence: true, length: { maximum: 255 }
  validates :age, presence: true, numericality: { only_integer: true, in: 0..100 }
  validates :value, presence: true, numericality: { only_integer: true }
  validates :term, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :description, length: { maximum: 255 }
  validates :isvalid, presence: true
  validates :event_type, presence: true, numericality: { only_integer: true, in: 0..10 }
end
