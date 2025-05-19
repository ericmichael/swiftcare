class Payment < ApplicationRecord
  belongs_to :claim, optional: true
  belongs_to :patient, optional: true

  enum :source, {stripe: 0, insurance: 1}

  validates :amount_cents, presence: true
  validates :source, presence: true
end
