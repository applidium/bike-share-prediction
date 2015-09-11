class DumpDataPointRow < DataPointRow
  def self.new_from_dump(bike_datapoint, holidays)
    row = DumpDataPointRow.new

    timestamp = bike_datapoint.created_at.to_datetime

    row.station = bike_datapoint.station
    row.open = bike_datapoint.open ? 1 : 0
    row.available_bikes = bike_datapoint.available_bikes

    row.build(timestamp, bike_datapoint.weather_data_point, holidays)
  end
end
