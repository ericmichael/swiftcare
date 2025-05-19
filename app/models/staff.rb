class Staff < ApplicationRecord
  self.inheritance_column = :type

  has_many :provider_schedules, foreign_key: :provider_id, dependent: :destroy
  has_many :appointments, foreign_key: :provider_id
  has_many :encounters, foreign_key: :provider_id

  validates :full_name, presence: true
end
