class CreateMobilityEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :mobility_entries, id: :uuid do |t|
      t.uuid :employee_id
      t.uuid :entity_id
      t.date :from_date
      t.date :to_date
      t.decimal :override_entity_soc_sec

      t.timestamps
    end
    add_index :mobility_entries, :employee_id
    add_index :mobility_entries, :entity_id
    add_index :mobility_entries, :from_date
    add_index :mobility_entries, :to_date
  end
end
