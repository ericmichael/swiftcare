class Claim < ApplicationRecord
  belongs_to :encounter
  belongs_to :patient_insurance
  belongs_to :authorization, optional: true
  belongs_to :payer, optional: true
  has_many :claim_line_items
  has_many :payments

  enum status: { draft: 0, submitted: 1, pending_payment: 2, paid: 3, denied: 4, void: 5 }
end
