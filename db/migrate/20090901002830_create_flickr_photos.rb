class CreateFlickrPhotos < ActiveRecord::Migration
  def self.up
    create_table :flickr_photos do |t|
      t.integer :flickr_id, :place_id
      t.integer :height_m, :width_m
      t.integer :rating
      t.string :title
      t.string :url_m
      t.string :owner
      t.timestamps
    end
  end

  def self.down
    drop_table :flickr_photos
  end
end
