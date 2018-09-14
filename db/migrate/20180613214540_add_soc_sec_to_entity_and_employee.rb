class AddSocSecToEntityAndEmployee < ActiveRecord::Migration[5.1]
  def change
    add_column :entities, :soc_sec, :decimal
    add_column :employees, :soc_sec, :decimal
  end
end
