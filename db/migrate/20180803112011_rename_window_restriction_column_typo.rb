class RenameWindowRestrictionColumnTypo < ActiveRecord::Migration[5.1]
  def change
    rename_column :window_restrictions, :employee_restricton, :employee_restriction
  end
end
