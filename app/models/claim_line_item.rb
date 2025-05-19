class ClaimLineItem < ApplicationRecord
  belongs_to :claim
  belongs_to :service_code

  validates :billed_amount_cents, presence: true
end
