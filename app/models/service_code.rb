class ServiceCode < ApplicationRecord
  enum code_type: { CPT: 0, HCPCS: 1, internal: 2 }

  validates :code, presence: true
end
