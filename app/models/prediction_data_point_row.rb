class PredictionDataPointRow < DataPointRow
  def self.new_for_prediction(station, datetime, hours_ahead, holidays, forecast)
    row = PredictionDataPointRow.new

    timestamp = datetime.beginning_of_hour + hours_ahead.hours
    weather_data_point = forecast.weather_data_point(timestamp)

    row.open = station.last_entry.open ? 1 : 0

    row.build(timestamp, weather_data_point, holidays)
  end
end
