class CreatePackageDimensionKeyNames < ActiveRecord::Migration
  def change
    create_table :package_dimension_key_names do |t|
      t.string :dimension

      t.timestamps
    end
  end
end
