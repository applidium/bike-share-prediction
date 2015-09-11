class AddLastEntryToStations < ActiveRecord::Migration
  def change
    add_column :stations, :last_entry, :integer
    add_index :stations, :last_entry
  end
end
