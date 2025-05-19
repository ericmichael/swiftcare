require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "address accessors" do
    loc = Location.new(name: "Clinic", street: "1", city: "Town", state: "ST", zip: "123")
    assert_equal "Town", loc.city
  end

  test "invalid without name" do
    loc = Location.new
    assert_not loc.valid?
  end
end
