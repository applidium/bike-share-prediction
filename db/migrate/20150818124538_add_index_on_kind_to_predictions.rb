class AddIndexOnKindToPredictions < ActiveRecord::Migration
  def change
    add_index :predictions, :kind
  end
end
