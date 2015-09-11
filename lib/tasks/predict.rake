require 'holiday'
require 'forecast'
require 'redis'

namespace :predict do
  task :all => :environment do
    puts "Predicting all stations..."

    redis = Redis.new(url: "redis://localhost:6379/0")

    hours_range = 24
    date = DateTime.now.hour < 12 ? Date.today : Date.tomorrow  # already past midday? predict for tomorrow
    action_datetime = date.to_datetime

    holidays = Holiday.holidays

    Contract.all.each do |contract|
      forecast = ForecastIO::Forecast.new(contract, date)

      contract.stations.each do |station|
        rows = (0..hours_range-1).map do |hour|
          PredictionDataPointRow.new_for_prediction(station, action_datetime, hour, holidays, forecast)
        end

        results = PredictionDataPointRow.import(rows)

        metadata = {
          :action_timestamp => action_datetime.to_i,
          :hours_range => hours_range,
          :prediction_table => Prediction.table_name,
          :rows_table => DumpDataPointRow.table_name,
          :station_id => station.id,
          :ids => results.ids,
        }

        redis.publish("prediction", metadata.to_json)
      end
    end

    puts "Predicted all stations."
  end
end
