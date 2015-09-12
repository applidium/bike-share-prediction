# Bike-Share-Prediction

This tool allows people wanting to get bikeshares usage prediction. It currently
works with the [Vélib'](http://www.velib.paris/) system but can be expanded to
any bikeshare system, especially any of the
[JCDecaux](https://developer.jcdecaux.com/#/opendata/vls?page=static) system in
a minute.

An example instance of the Webservice is running on Heroku, you can access it
here: [http://bike-share-prediction-example.herokuapp.com](http://bike-share-prediction-example.herokuapp.com).
It contains stations of the Vélib' contract, but does not make any prediction.

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

Alternatively, you can set API keys as environment variables, suffixed with `\_APIKEY`:

  $ export JCDECAUX_APIKEY=xxxx
  $ export OPENWEATHERMAP_APIKEY=xxxx
  $ export FORECASTIO_APIKEY=xxxx
  $ bundle exec rails server

### Prediction backend

This repository comes packaged with a scikit-learn-based prediction backend,
to get it to run, you will need a [Redis](http://redis.io) server running on
port 6379, if it is running on another port, please change it in
[`prediction/worker.py`](https://github.com/applidium/bike-share-prediction/blob/master/prediction/worker.py#L41)
and [`lib/tasks/predict.rake`](https://github.com/applidium/bike-share-prediction/blob/master/lib/tasks/predict.rake#L9).

Once Redis is running, run `prediction/worker.py` (install requirements located
in `prediction/requirements.txt` before, works well with Python virtualenv).

The worker will subscribe to a Redis Pub/Sub channel. Once a day, Rails will
publish metadata asking to predict usage for the next day, the Python worker
will treat these metadata and predict using scikit-learn's `linear_model.Lasso`
and `linear_model.Ridge` algorithms.

You can add another prediction backend and turn the Python worker off if you
have your own implementation of a prediction algorithm.

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
