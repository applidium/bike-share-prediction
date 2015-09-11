class AddKindFieldToPrediction < ActiveRecord::Migration
  def change
    add_column :predictions, :kind, :string, default: "scikit_lasso"
  end
end
