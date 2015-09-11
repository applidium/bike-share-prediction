# Fetch data from api
def _fetch(url, params = {})
  uri = URI.parse(url)
  uri.query = URI.encode_www_form(params)

  JSON.parse(Net::HTTP.get(uri))
end

# Fetch all stations
def fetch_stations(contract)
  _fetch(
    "https://api.jcdecaux.com/vls/v1/stations",
    apiKey: ApiKeys::JCDECAUX, contract: contract
  )
end

# Fetch weather informations
def fetch_weather(lat, lon)
  _fetch(
    "http://api.openweathermap.org/data/2.5/weather",
    appid: ApiKeys::OPENWEATHERMAP, lat: lat, lon: lon
  )
end

namespace :fetch do
  task :populate => :environment do
    puts "Creating Paris contract..."

    contract = Contract.find_or_create_by(name: "Paris", latitude: 48.85, longitude: 2.35)

    puts "Fetching stations..."

    fetched_stations = fetch_stations(contract.name)

    fetched_stations.each do |station|
      station = Station.jcdecaux_new(station, contract)
      station.save if station.present?
    end

    puts "Stations fetched."
  end

  task :fetch => :environment do
    puts "Fetching data..."

    Contract.all.each do |contract|
      puts "Fetching stations for #{contract.name}..."
      fetched_stations = fetch_stations(contract.name)

      puts "Fetching weather information..."
      fetched_weather = fetch_weather(contract.latitude, contract.longitude)
      weather_data_point = WeatherDataPoint.owm_new(fetched_weather, contract)
      weather_data_point.save if weather_data_point.present?

      fetched_stations.each do |station|
        datapoint = BikeDataPoint.jcdecaux_new(station, weather_data_point)
        datapoint.save if datapoint.present?
      end
    end

    puts "Data fetched."
  end
end
