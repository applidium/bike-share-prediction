class AddLatitudeAndLongitudeToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :latitude, :float
    add_column :contracts, :longitude, :float
  end
end
