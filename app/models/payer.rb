class Payer < ApplicationRecord
  include HasAddress

  has_many :payer_contracts, dependent: :destroy
  has_many :claims, dependent: :nullify

  validates :name, presence: true
  validates :payer_identifier, presence: true
end
