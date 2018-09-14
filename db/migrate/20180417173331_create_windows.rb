class CreateWindows < ActiveRecord::Migration[5.1]
  def change
    create_table :windows, id: :uuid do |t|
      t.uuid :tenant_id
      t.datetime :start_time
      t.datetime :end_time
      t.datetime :payment_deadline
      t.string :type

      t.timestamps
      t.index ["tenant_id"], name: "index_tenant_id_on_windows"
    end
  end
end
