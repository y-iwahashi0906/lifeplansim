class Event < ApplicationRecord
  belongs_to :asset_sim
  validates :event_type, presence: true, numericality: {only_integer: true, in: 0..100 }
  validates :event_age, presence: true, numericality: {only_integer: true, in: 0..100 }
  validates :event_value, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :event_term, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
end
