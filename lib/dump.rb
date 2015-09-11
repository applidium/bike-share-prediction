require './lib/holiday'

class Dump
  def initialize(time_delta)
    @time_delta = time_delta
  end

  def station(station)
    from_datetime = last_datetime(station)

    datapoints = BikeDataPoint.where(station: station).where("created_at >= ?", from_datetime).order(:created_at).to_a

    current_datetime = station.last_dump || datapoints.first.created_at.to_datetime

    current_datetime, i = [from_datetime, 0]
    rows = []

    loop do
      i += 1 while i < datapoints.length and datapoints[i].created_at < current_datetime

      break if i == datapoints.length

      datapoint = datapoints[i].dup
      datapoint.created_at = current_datetime

      # # find the next weather_data_point after if blank
      if datapoint.weather_data_point.blank?
        datapoint.weather_data_point = WeatherDataPoint.where("created_at >= ?", current_datetime).order(:created_at).first
      end

      rows << DumpDataPointRow.new_from_dump(datapoint, Dump.holidays)

      current_datetime += @time_delta.minute
    end

    DumpDataPointRow.import(rows)

    # new last dump timestamp
    station.update_attributes({ last_dump: current_datetime })
  end

  private
  def last_datetime(station)
    station.last_dump || BikeDataPoint.order(:created_at).first.created_at.to_datetime
  end

  @@holidays = nil

  def self.holidays
    return @@holidays if @@holidays.present?
    @@holidays = Holiday.holidays
  end
end
