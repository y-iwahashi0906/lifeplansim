class AssetSim < ApplicationRecord
  belongs_to :user
  validates :cash, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :investment_asset, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :income, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :expense, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :investment_ratio, presence: true, numericality: {only_integer: true, in: 0..100 }
  validates :investment_yield, presence: true, numericality: {only_float: true, in: 0..100 }
  validates :inflation_ratio, presence: true, numericality:  {only_float: true, in: 0..100 }
  
  has_many :events, dependent: :destroy
end
