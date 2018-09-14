class CreateWindowEmployeeRestrictions < ActiveRecord::Migration[5.1]
  def change
    create_table :window_employee_restrictions, id: :uuid do |t|
      t.uuid :employee_id
      t.uuid :window_restriction_id

      t.timestamps
    end
    add_index :window_employee_restrictions, :employee_id
    add_index :window_employee_restrictions, :window_restriction_id
  end
end
