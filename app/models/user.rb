class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :birth, presence: true
  
  has_secure_password
  has_many :asset_sims, dependent: :destroy
  
  def age
    today = Time.zone.today
    this_years_birthday = Time.zone.local(today.year, birth.month, birth.day)
    age = today.year - birth.year
    if today < this_years_birthday
      age -= 1
    end
    return age.to_i
  end
end
