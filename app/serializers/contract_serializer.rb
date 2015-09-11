class ContractSerializer < ActiveModel::Serializer
  attributes :id, :name, :latitude, :longitude, :stations_count

  def stations_count
    self.object.stations.count
  end
end
