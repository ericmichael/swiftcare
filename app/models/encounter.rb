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

  enum status: { in_progress: 0, completed: 1, canceled: 2 }
end
