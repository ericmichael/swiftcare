module JsonSerializable
  extend ActiveSupport::Concern

  class_methods do
    def json_fields(*fields)
      fields.each do |field|
        attribute field, :json, default: {}
      end
    end
  end
end
