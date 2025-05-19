class Payer < ApplicationRecord
  has_many :payer_contracts
  has_many :claims
end
