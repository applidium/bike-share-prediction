class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.references :station, index: true, foreign_key: true
      t.datetime :datetime
      t.integer :available_bikes

      t.timestamps null: false
    end
  end
end
