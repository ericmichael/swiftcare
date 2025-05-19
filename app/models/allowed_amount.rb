class AllowedAmount < ApplicationRecord
  belongs_to :payer_contract
  belongs_to :service_code
end
