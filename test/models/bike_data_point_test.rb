require 'test_helper'

class BikeDataPointTest < ActiveSupport::TestCase
    test "create_empty_bad" do
        data = {}

        weather_data_point = WeatherDataPoint.take

        assert_not BikeDataPoint.create_from_json(data, weather_data_point).valid?
    end

    test "create_bad" do
        data = {
            "last_update" => 42
        }

        weather_data_point = WeatherDataPoint.take

        assert_not BikeDataPoint.create_from_json(data, weather_data_point).valid?
    end

    test "create_good" do
        data = {
            "last_update" => 45,
            "number" => 42,
            "available_bike_stands" => 12,
            "status" => "CLOSED"
        }

         weather_data_point = WeatherDataPoint.take

         Station.create(number: 42, name: "AA", bike_stands: 12)

        assert BikeDataPoint.create_from_json(data, weather_data_point).valid?
    end
end
