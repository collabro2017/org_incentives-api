class CreateVestingEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :vesting_events, id: :uuid do |t|
      t.uuid "award_id", null: false
      t.date "vestedDate", null: false
      t.integer "quantity", null: false
      t.decimal "strike", null: false
      t.timestamps
    end
  end
end
