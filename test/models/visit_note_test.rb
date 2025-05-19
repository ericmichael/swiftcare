require "test_helper"

class VisitNoteTest < ActiveSupport::TestCase
  test "has body presence validator" do
    assert VisitNote.validators_on(:body).any? { |v| v.is_a?(ActiveModel::Validations::PresenceValidator) }
  end
end
