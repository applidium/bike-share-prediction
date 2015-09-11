class CreateBikeDataPoints < ActiveRecord::Migration
  def change
    create_table :bike_data_points do |t|
      t.integer :available_bikes
      t.boolean :open
      t.references :weather_data_point, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
