class AddWindowIdToWindowRestrictions < ActiveRecord::Migration[5.1]
  def change
    add_column :window_restrictions, :window_id, :uuid, index: true
  end
end
