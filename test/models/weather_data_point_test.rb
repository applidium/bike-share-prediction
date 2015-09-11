require 'test_helper'

class WeatherDataPointTest < ActiveSupport::TestCase
    test "create_empty_bad" do
        data = {}

        contract = Contract.take

        assert_not WeatherDataPoint.create_from_json(data, contract).valid?
    end

    test "create_good" do
        data = {
            "weather" => [{
                "main" => "Sunny"
            }],

            "main" => {
                "temp" => 291.5,
                "humidity" => 33,
            },

            "wind" => {
                "speed" => 2.2
            }
        }

        contract = Contract.take

        assert WeatherDataPoint.create_from_json(data, contract).valid?
    end
end
