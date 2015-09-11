module ApiKeys
  @config = YAML.load_file("#{Rails.root}/config/api_keys.yml").symbolize_keys

  # define JCDECAUX & OPENWEATHERMAP constants
  @config.each do |key, value|
    const_set key.upcase, value
  end
end
