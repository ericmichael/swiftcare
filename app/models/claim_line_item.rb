class ClaimLineItem < ApplicationRecord
  belongs_to :claim
  belongs_to :service_code
end
