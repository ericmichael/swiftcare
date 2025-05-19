class PayerContract < ApplicationRecord
  belongs_to :payer
  has_many :allowed_amounts
end
