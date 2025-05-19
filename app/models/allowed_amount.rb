class AllowedAmount < ApplicationRecord
  belongs_to :payer_contract
  belongs_to :service_code

  validates :allowed_cents, presence: true
end
