class CreateLayers < ActiveRecord::Migration
  def self.up
    create_table :layers do |t|
      t.integer :position, :default => 0, :null => false
      t.integer :calculation_id
      t.integer :material_id
      t.float :angle, :default => 0, :null => false
      t.float :thickness, :default => 0, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :layers
  end
end
