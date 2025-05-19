class Staff < ApplicationRecord
  include JsonSerializable

  self.inheritance_column = :type

  has_many :provider_schedules, foreign_key: :provider_id, dependent: :destroy
  has_many :appointments, foreign_key: :provider_id
  has_many :encounters, foreign_key: :provider_id

  json_fields :specialties_json, :board_certifications_json

  validates :full_name, presence: true
end
