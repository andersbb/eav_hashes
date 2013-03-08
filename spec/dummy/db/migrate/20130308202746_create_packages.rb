class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.boolean :is_envelope

      t.timestamps
    end
  end
end
