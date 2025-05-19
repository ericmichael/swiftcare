class Encounter < ApplicationRecord
  belongs_to :patient
  belongs_to :provider, class_name: 'Staff'
  belongs_to :location
  belongs_to :appointment, optional: true

  has_many :vitals
  has_many :lab_results
  has_many :visit_notes
  has_many :diagnoses
  has_many :orders
  has_one :claim

  enum :status, { in_progress: 0, completed: 1, canceled: 2 }
  enum :visit_type, { office: 0, telehealth: 1 }

  validates :started_at, presence: true
  validates :status, presence: true
  validate :ended_after_started

  private

  def ended_after_started
    return if ended_at.blank? || started_at.blank?
    errors.add(:ended_at, "must be after start") if ended_at < started_at
  end
end
