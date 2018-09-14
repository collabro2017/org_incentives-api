class CreateWindowRestrictions < ActiveRecord::Migration[5.1]
  def change
    create_table :window_restrictions, id: :uuid do |t|
      t.boolean :employee_restricton

      t.timestamps
    end
  end
end
