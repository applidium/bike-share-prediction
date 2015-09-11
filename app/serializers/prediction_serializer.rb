class PredictionSerializer < ActiveModel::Serializer
  attributes :timestamp, :available_bikes

  def timestamp
    self.object.datetime.to_i
  end
end
