class Contract < ActiveRecord::Base
  has_many :stations, dependent: :destroy
  has_many :weather_data_points, dependent: :destroy
end
