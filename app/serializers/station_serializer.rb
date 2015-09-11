class StationSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :bike_stands, :latitude, :longitude, :contract_id, :last_entry
  has_many :predictions

  def last_entry
    {
      :timestamp => self.object.last_entry.created_at.to_i,
      :availableBikeStands => self.object.last_entry.available_bikes
    }
  end

  def predictions
    self.object.predictions.today.of_kind("scikit_lasso").order(:datetime)
  end
end
