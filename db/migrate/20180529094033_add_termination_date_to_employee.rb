class AddTerminationDateToEmployee < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :termination_date, :date
  end
end
