require './lib/datetime'

class BikeDataPoint < ActiveRecord::Base
  belongs_to :weather_data_point
  belongs_to :station

  validates :available_bikes, presence: true
  validates :open, :inclusion => {:in => [true, false]}

  scope :today, -> { where("bike_data_points.created_at >= ? and bike_data_points.created_at <= ?", DateTime.now.beginning_of_day, DateTime.now.end_of_day) }

  def self.jcdecaux_new(json, weather_data_point)
    last_update = json["last_update"]
    number = json["number"]

    return if last_update.nil? or number.nil?

    station = Station.find_by(number: number)

    # station not foudn or data already in database
    return if station.nil? or station.last_update == last_update

    available_bikes = json["available_bikes"]
    open = json["status"] == "OPEN"

    # unix epoch to ruby datetime object
    timestamp = Time.at(last_update / 1000).to_datetime

    BikeDataPoint.new(
      available_bikes: available_bikes,
      open: open,
      station: station,
      weather_data_point: weather_data_point,
      created_at: timestamp
    )
  end
end
