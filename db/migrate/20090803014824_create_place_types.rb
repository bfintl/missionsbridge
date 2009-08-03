class CreatePlaceTypes < ActiveRecord::Migration
  def self.up
    create_table :place_types do |t|
      t.string :name
      t.integer :code
      t.timestamps
    end
    change_table :places do |t|
      t.integer :place_type_id
    end
  end

  def self.down
    drop_table :place_types
  end
end
