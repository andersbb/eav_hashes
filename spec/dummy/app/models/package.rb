class Package < ActiveRecord::Base
  attr_accessible :is_envelope
  eav_hash_for :size, constraint_model: 'PackageDimensionKeyName', constraint_column: 'dimension'
end
