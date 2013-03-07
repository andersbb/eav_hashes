class CreateCustomerAddress < ActiveRecord::Migration
  def change
    create_table :customer_address do |t|
      t.references :customer, :null => false
      t.string :entry_key, :null => false
      t.text :value, :null => false
      t.integer :value_type, :null => false
      t.boolean :symbol_key, :null => false, :default => true

      t.timestamps
    end

    add_index :customer_address, :customer_id
    add_index :customer_address, :entry_key
  end
end