# Bike-Share-Prediction

This tool allows people wanting to get bikeshares usage prediction. It currently
works with the [Vélib'](http://www.velib.paris/) system but can be expanded to
any bikeshare system, especially any of the
[JCDecaux](https://developer.jcdecaux.com/#/opendata/vls?page=static) system in
a minute.

## Installation

* Get API key from [JCDecaux Developer](https://developer.jcdecaux.com/#/account)
* Get API key from [OpenWeatherMap](http://home.openweathermap.org/)
* Get API key from [forecast.io](https://developer.forecast.io/) (max. 1000 calls per day)
* Create a `config/api_keys.yml` file with this format:
  ```
  jcdecaux: API_KEY
  openweathermap: API_KEY
  forecastio: API_KEY
  ```

* `bundle install`
* `bundle exec rake db:create`
* `bundle exec rake db:migrate`
* `bundle exec whenever -i`
* `bundle exec rake fetch:populate` will create Vélib' contract, you can add other systems here if you want to
* `bundle exec rails server`
* Enjoy.

## Routes

* `GET /contacts`
* `GET /contracts/:contract_id/stations`
* `GET /stations/:station_id`

## Add a contract

### JCDecaux

Simply add a new `Contract` object to the database, the `name` must be the name
used to fetch data from JCDecaux, `latitude` and `longitude` are there for
OpenWeatherMap and forecast.io.

### Other

You will have to write a rake task, indicating how data are fetch, see
`lib/tasks/fetch.rake` for the format.

## Future work

There are a couple of improvements that could be done. Feel free to send us pull
requests if you want to contribute!

* Add a new prediction method (with scikit-learn or something else)
* Add new bikeshare systems
* More?
