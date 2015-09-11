class AddStationToBikeDataPoints < ActiveRecord::Migration
  def change
    add_reference :bike_data_points, :station, index: true, foreign_key: true
  end
end
