class DataPointRow < ActiveRecord::Base
  belongs_to :station

  def build(timestamp, weather_data_point, holidays)
    self.assign_attributes({
      weather: weather_data_point.weather_mapping,
      temperature: weather_data_point.temperature,
      wind_speed: weather_data_point.wind_speed,
      humidity: weather_data_point.humidity,

      hour: timestamp.hour,
      minute: timestamp.minute,
      day_of_week: timestamp.wday,
      week_number: timestamp.week,
      season: timestamp.season_mapping,
      weekend: [0, 6].include?(timestamp.wday) ? 1 : 0,
      holiday: holidays.holiday?(timestamp) ? 1 : 0
    })

    return self
  end
end
