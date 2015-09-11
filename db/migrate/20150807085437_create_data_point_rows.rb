class CreateDataPointRows < ActiveRecord::Migration
  def change
    create_table :data_point_rows do |t|
      t.integer :open
      t.integer :weather
      t.decimal :temperature
      t.decimal :wind_speed
      t.integer :humidity
      t.integer :hour
      t.integer :minute
      t.integer :day_of_week
      t.integer :week_number
      t.integer :season
      t.integer :weekend
      t.integer :holiday
      t.integer :available_bikes
      t.references :station, index: true, foreign_key: true
      t.string :type

      t.timestamps null: false
    end
  end
end
