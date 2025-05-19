require "test_helper"

class PayerContractTest < ActiveSupport::TestCase
  setup do
    @payer = Payer.create!(name: "Payer", payer_identifier: "123")
  end

  test "invalid without effective_date" do
    contract = PayerContract.new(payer: @payer, name: "Base")
    assert_not contract.valid?
  end
end
