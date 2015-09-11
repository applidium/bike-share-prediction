class AddNumberToStations < ActiveRecord::Migration
  def change
    add_column :stations, :number, :integer
  end
end
