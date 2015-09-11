module ForecastIO

  class Forecast
    attr_reader :weather_data_points

    def initialize(contract, date)
      ForecastIO.api_key = ApiKeys::FORECASTIO
      data = ForecastIO.forecast(
        contract.latitude, contract.longitude,
        time: date.to_datetime, params: { units: 'si' }
      )

      @weather_data_points = data.hourly.data.map do |forecast_data|
        datapoint = WeatherDataPoint.forecast_io_new(forecast_data, contract)
        datapoint.created_at = DateTime.strptime("#{forecast_data.time}", "%s")
        datapoint
      end
    end

    # returns closest weather_data_point to datetime
    def weather_data_point(datetime)
      @weather_data_points.each do |point|
        return point if point.created_at >= datetime
      end

      @weather_data_points.last
    end
  end

end
