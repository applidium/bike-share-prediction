class AddLastDumpFieldToStation < ActiveRecord::Migration
  def change
    add_column :stations, :last_dump, :datetime
  end
end
