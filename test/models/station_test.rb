require 'test_helper'

class StationTest < ActiveSupport::TestCase
    test "create_empty_bad" do
        data = {}

        contract = Contract.take

        assert_not Station.create_from_json_if_not_exists(data, contract).valid?
    end

    test "create_bad" do
        data = {
            "number" => 42,
            "name" => "Brave new station 1",
            "address" => "20 Rue Alo",

            "position" => {
                "lat" => 48.85,
                "lng" => 2.35
            }
        }

        contract = Contract.take

        assert_difference "Station.count", 0 do
            Station.create_from_json_if_not_exists(data, contract)
        end
    end

    test "create_good" do
        data = {
            "number" => 42,
            "name" => "Brave new station 2",
            "address" => "20 Rue Alo",

            "position" => {
                "lat" => 48.85,
                "lng" => 2.35
            },

            "bike_stands" => 42
        }

        contract = Contract.take

        assert Station.create_from_json_if_not_exists(data, contract).valid?
    end
end
