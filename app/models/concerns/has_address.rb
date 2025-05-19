module HasAddress
  extend ActiveSupport::Concern

  included do
    include JsonSerializable
    store_accessor :address_json, :street, :city, :state, :zip
    json_fields :address_json
  end
end
