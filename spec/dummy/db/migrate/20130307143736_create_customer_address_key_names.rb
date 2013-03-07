class CreateCustomerAddressKeyNames < ActiveRecord::Migration
  def change
    create_table :customer_address_key_names do |t|
      t.string :name

      t.timestamps
    end
  end
end
