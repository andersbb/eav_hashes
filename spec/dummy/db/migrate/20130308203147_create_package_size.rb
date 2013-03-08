class CreatePackageSize < ActiveRecord::Migration
  def change
    create_table :package_size do |t|
      t.references :package, :null => false
      t.string :entry_key, :null => false
      t.text :value, :null => false
      t.integer :value_type, :null => false
      t.boolean :symbol_key, :null => false, :default => true

      t.timestamps
    end

    add_index :package_size, :package_id
    add_index :package_size, :entry_key
  end
end