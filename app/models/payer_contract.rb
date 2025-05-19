class PayerContract < ApplicationRecord
  belongs_to :payer
  has_many :allowed_amounts

  validates :name, presence: true
  validates :effective_date, presence: true
end
