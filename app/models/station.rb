class Station < ActiveRecord::Base
  belongs_to :contract
  has_many :bike_data_points, dependent: :destroy
  has_one :last_entry, :class_name => "BikeDataPoint"
  has_many :predictions

  validates :number, presence: true
  validates :name, presence: true
  validates :bike_stands, presence: true

  def self.jcdecaux_new(json, contract)
    # no coordinates -> no weather informations -> useless
    return if json["position"].nil?

    number = json["number"]
    latitude = json["position"]["lat"]
    longitude = json["position"]["lng"]
    bike_stands = json["bike_stands"]

    # 05006 - SAINT JACQUES SOUFFLOT -> Saint Jacques Soufflot
    name = json["name"].mb_chars.split(" - ")[1..-1].join(" - ").split.map(&:capitalize).join(" ")

    # 174 RUE SAINT JACQUES - 75005 PARIS -> 174 Rue Saint Jacques - 75005 Paris
    address = json["address"].mb_chars.split.map(&:capitalize).join(" ")

    # station already exists?
    station = Station.find_by(number: number, contract: contract)
    station = Station.new if station.blank?

    station.assign_attributes({
      number: number,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      bike_stands: bike_stands,
      contract: contract
    })

    station
  end

  def prediction_row(datetime, hours_ahead, holidays, forecast)
    current_datetime = datetime + hours_ahead.hours
    weather_data_point = forecast.weather_data_point(current_datetime)

    {
      :open? => self.last_entry.open ? 1 : 0,  # Can we do better?
      :weather => weather_data_point.weather_mapping,
      :temperature => weather_data_point.temperature,
      :wind_speed => weather_data_point.wind_speed,
      :humidity => weather_data_point.humidity,
      :hour => current_datetime.hour,
      :minute => current_datetime.minute,
      :day_of_week => current_datetime.wday,
      :week_number => current_datetime.week,
      :season => current_datetime.season_mapping,
      :weekend? => [0, 6].include?(current_datetime.wday) ? 1 : 0,
      :holiday? => holidays.holiday?(current_datetime) ? 1 : 0
    }
  end

  def self.prediction_columns
    [:open?, :weather, :temperature, :wind_speed,
      :humidity, :hour, :minute, :day_of_week, :week_number,
      :season, :weekend?, :holiday?, :available_bikes]
  end
end
