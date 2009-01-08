class CreateCalculations < ActiveRecord::Migration
  def self.up
    create_table :calculations do |t|
      t.string :title
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :calculations
  end
end
