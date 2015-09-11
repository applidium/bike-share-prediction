class Prediction < ActiveRecord::Base
  belongs_to :station

  scope :today, -> { where("predictions.datetime >= ? and predictions.datetime <= ?", DateTime.now.beginning_of_day, DateTime.now.end_of_day) }
  scope :of_kind, ->(kind) { where(kind: kind) }
end
