require "test_helper"

class AllowedAmountTest < ActiveSupport::TestCase
  setup do
    payer = Payer.create!(name: "P", payer_identifier: "123")
    contract = PayerContract.create!(payer: payer, name: "Base", effective_date: Date.today)
    @service = ServiceCode.create!(code_type: :CPT, code: "99213")
    @allowed = AllowedAmount.new(payer_contract: contract, service_code: @service)
  end

  test "invalid without allowed_cents" do
    assert_not @allowed.valid?
  end

  test "valid with required attributes" do
    @allowed.allowed_cents = 100
    assert @allowed.valid?
  end
end
