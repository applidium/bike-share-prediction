module ApiKeys
  config_path = "#{Rails.root}/config/api_keys.yml"
  if File.exists?(config_path)
    @config = YAML.load_file(config_path).symbolize_keys

    # define JCDECAUX, OPENWEATHERMAP & FORECASTIO constants
    @config.each do |key, value|
      const_set key.upcase, value
    end
  end

  # better to run on Heroku
  ENV.each do |var, value|
    if var.end_with?("_APIKEY")
      const_set var[0..-8], value
    end
  end
end
