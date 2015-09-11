class AddContractToStation < ActiveRecord::Migration
  def change
    add_reference :stations, :contract, index: true, foreign_key: true
  end
end
