class AddEmployeeIdentificationToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :internal_identification, :string
    add_index :employees, [:tenant_id, :internal_identification], :unique => true, :name => 'by_employee_internal_identification'
  end
end
