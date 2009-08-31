class CreatePersonPlaceConnections < ActiveRecord::Migration
  def self.up
    create_table :person_place_connections do |t|

      t.integer :person_id
      t.integer :place_id

      t.boolean :been_to
      t.boolean :has_contacts
      t.boolean :wants_to_go

      t.timestamps
    end
  end

  def self.down
    drop_table :person_place_connections
  end
end
