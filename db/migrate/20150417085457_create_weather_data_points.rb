class CreateWeatherDataPoints < ActiveRecord::Migration
  def change
    create_table :weather_data_points do |t|
      t.string :weather
      t.float :temperature
      t.float :wind_speed
      t.integer :humidity
      t.references :contract, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
