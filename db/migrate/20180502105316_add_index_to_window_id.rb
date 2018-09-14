class AddIndexToWindowId < ActiveRecord::Migration[5.1]
  def change
    add_index :purchase_configs, :window_id
  end
end
