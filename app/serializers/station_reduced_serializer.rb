class StationReducedSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :bike_stands, :latitude, :longitude, :contract_id
end
