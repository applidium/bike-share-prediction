class WeatherDataPoint < ActiveRecord::Base
  belongs_to :contract

  validates :weather, presence: true
  validates :temperature, presence: true
  validates :wind_speed, presence: true
  validates :humidity, presence: true

  def self.owm_new(json, contract)
    return if ["weather", "main", "wind"].any? { |x| json[x].nil? }
    return if json["weather"].empty?

    weather = json["weather"][0]["main"]
    temperature = json["main"]["temp"]
    humidity = json["main"]["humidity"]
    wind_speed = json["wind"]["speed"]

    WeatherDataPoint.new(
      weather: weather,
      temperature: temperature,
      wind_speed: wind_speed,
      humidity: humidity,
      contract: contract
    )
  end

  # maps data from forecast.io to an owm-compliant weather_data_point
  def self.forecast_io_new(forecast_data, contract)
    weather = forecast_io_to_owm_weather(forecast_data.icon)
    temperature = forecast_data.temperature + 273.15          # Celcius -> Kelvin
    humidity = (forecast_data.humidity * 100.0).to_i          # [0..1] -> [0..100]
    wind_speed = forecast_data.windSpeed

    WeatherDataPoint.new(
      weather: weather,
      temperature: temperature,
      wind_speed: wind_speed,
      humidity: humidity,
      contract: contract
    )
  end

  # map open weather map string -> integer (for prediction purpose)
  def weather_mapping
    mapping = {
      "Thunderstorm" => 0, "Drizzle" => 1, "Rain" => 2, "Snow" => 3,
      "Atmosphere" => 4, "Clouds" => 5, "Extreme" => 6, "Additional" => 7,
      "Clear" => 8, "Mist" => 9
    }

    mapping[self.weather] || mapping.values.max + 1
  end

  private
  def self.forecast_io_to_owm_weather(weather)
    # mapping ForecastIO -> OWM
    forecast_mapping = {
      "clear-day" => "Clear", "clear-night" => "Clear", "rain" => "Rain",
      "snow" => "Snow", "sleet" => "Snow", "wind" => "Clouds", "fog" => "Mist",
      "partly-cloudy-day" => "Clouds", "partly-cloudy-night" => "Clouds",
      "cloudy" => "Clouds",
    }

    forecast_mapping[weather]
  end
end
