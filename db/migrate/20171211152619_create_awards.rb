class CreateAwards < ActiveRecord::Migration[5.1]
  def change
    create_table :awards, id: :uuid do |t|
      t.date "grantDate", null: false
      t.date "expiryDate", null: false
      t.json "vesting"
      t.numeric "quantity", null: false
      t.timestamps
      t.uuid "employee_id", null: false
      t.uuid "incentive_sub_program_id", null: false
      t.index ["incentive_sub_program_id"], name: "index_incentive_sub_program_on_awards"
      t.index ["employee_id"], name: "index_employee_id_on_awards"
    end
  end
end
