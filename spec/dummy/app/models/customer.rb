class Customer < ActiveRecord::Base
  attr_accessible :name
  eav_hash_for :address, constraint_model: 'CustomerAddressKeyName'
end
