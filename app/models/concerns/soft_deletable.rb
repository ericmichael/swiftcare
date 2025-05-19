module SoftDeletable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(deleted_at: nil) }
    default_scope { active }
  end

  def soft_delete
    update(deleted_at: Time.current)
  end
end
