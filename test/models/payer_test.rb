require "test_helper"

class PayerTest < ActiveSupport::TestCase
  test "invalid without payer_identifier" do
    payer = Payer.new(name: "Acme")
    assert_not payer.valid?
  end
end
