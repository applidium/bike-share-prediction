class StationsLastUpdateBigInt < ActiveRecord::Migration
    def up
        change_column :stations, :last_update, :bigint
    end
    
    def down
        change_column :stations, :last_update, :integer
    end
end
