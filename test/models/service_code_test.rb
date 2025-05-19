require "test_helper"

class ServiceCodeTest < ActiveSupport::TestCase
  test "enum code_type includes CPT" do
    assert_includes ServiceCode.code_types.keys, "CPT"
  end

  test "invalid without code" do
    sc = ServiceCode.new(code_type: :CPT)
    assert_not sc.valid?
  end

  test "valid with required attributes" do
    sc = ServiceCode.new(code_type: :CPT, code: "99213")
    assert sc.valid?
  end
end
