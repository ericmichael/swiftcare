class ClaimLineItem < ApplicationRecord
  include JsonSerializable

  belongs_to :claim
  belongs_to :service_code

  json_fields :diagnosis_pointer_json

  validates :billed_amount_cents, presence: true
end
