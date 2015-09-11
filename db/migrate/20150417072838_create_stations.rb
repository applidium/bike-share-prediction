class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :bike_stands
      t.integer :last_update

      t.timestamps null: false
    end
  end
end
