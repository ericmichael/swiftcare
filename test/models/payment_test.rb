require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  test "invalid without amount_cents" do
    payment = Payment.new(source: :stripe)
    assert_not payment.valid?
  end

  test "valid with required attributes" do
    payment = Payment.new(source: :stripe, amount_cents: 100)
    assert payment.valid?
  end
end
