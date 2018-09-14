class CreateEmployeeDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :employee_documents, id: :uuid do |t|
      t.boolean :is_read_and_accepted
      t.boolean :requires_acceptance
      t.uuid :employee_id

      t.timestamps
      t.index ["employee_id"], name: "index_employee_id_on_employee_documents"
    end
  end
end
