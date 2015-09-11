# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150818124538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bike_data_points", force: :cascade do |t|
    t.integer  "available_bikes"
    t.boolean  "open"
    t.integer  "weather_data_point_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "station_id"
  end

  add_index "bike_data_points", ["station_id"], name: "index_bike_data_points_on_station_id", using: :btree
  add_index "bike_data_points", ["weather_data_point_id"], name: "index_bike_data_points_on_weather_data_point_id", using: :btree

  create_table "contracts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "data_point_rows", force: :cascade do |t|
    t.integer  "open"
    t.integer  "weather"
    t.decimal  "temperature"
    t.decimal  "wind_speed"
    t.integer  "humidity"
    t.integer  "hour"
    t.integer  "minute"
    t.integer  "day_of_week"
    t.integer  "week_number"
    t.integer  "season"
    t.integer  "weekend"
    t.integer  "holiday"
    t.integer  "available_bikes"
    t.integer  "station_id"
    t.string   "type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "data_point_rows", ["station_id"], name: "index_data_point_rows_on_station_id", using: :btree

  create_table "predictions", force: :cascade do |t|
    t.integer  "station_id"
    t.datetime "datetime"
    t.integer  "available_bikes"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "kind",            default: "scikit_lasso"
  end

  add_index "predictions", ["kind"], name: "index_predictions_on_kind", using: :btree
  add_index "predictions", ["station_id"], name: "index_predictions_on_station_id", using: :btree

  create_table "stations", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "bike_stands"
    t.integer  "last_update", limit: 8
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "contract_id"
    t.integer  "number"
    t.integer  "last_entry"
    t.datetime "last_dump"
  end

  add_index "stations", ["contract_id"], name: "index_stations_on_contract_id", using: :btree
  add_index "stations", ["last_entry"], name: "index_stations_on_last_entry", using: :btree

  create_table "weather_data_points", force: :cascade do |t|
    t.string   "weather"
    t.float    "temperature"
    t.float    "wind_speed"
    t.integer  "humidity"
    t.integer  "contract_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "weather_data_points", ["contract_id"], name: "index_weather_data_points_on_contract_id", using: :btree

  add_foreign_key "bike_data_points", "stations"
  add_foreign_key "bike_data_points", "weather_data_points"
  add_foreign_key "data_point_rows", "stations"
  add_foreign_key "predictions", "stations"
  add_foreign_key "stations", "contracts"
  add_foreign_key "weather_data_points", "contracts"
end
