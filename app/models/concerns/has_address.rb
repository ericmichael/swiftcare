module HasAddress
  extend ActiveSupport::Concern

  included do
    store_accessor :address_json, :street, :city, :state, :zip
  end
end
