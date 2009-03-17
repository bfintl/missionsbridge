class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|

      t.string :name
      t.string :permalink
      t.string :long_name
      t.string :parent_names
      t.string :color, :limit => 6
      
      t.integer :woeid
      
      t.string :country, :country_code, :country_type

      t.string :admin1, :admin1_code, :admin1_type
      t.string :admin2, :admin2_code, :admin2_type
      t.string :admin3, :admin3_code, :admin3_type
      
      t.string :locality1, :locality1_type
      t.string :locality2, :locality2_type
      
      t.with_options :precision => 15, :scale => 10 do |c|
        c.decimal :bounding_box_northeast_lat
        c.decimal :bounding_box_northeast_lon
        c.decimal :bounding_box_southwest_lat
        c.decimal :bounding_box_southwest_lon
        c.decimal :centroid_lat
        c.decimal :centroid_lon
      end
      
      t.string :lang
      t.string :place_type_name
      t.string :postal, :postal_type
      t.string :uri
      
      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
