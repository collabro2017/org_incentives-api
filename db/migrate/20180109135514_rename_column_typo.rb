class RenameColumnTypo < ActiveRecord::Migration[5.1]
  def change
    rename_column :features, :excercise, :exercise
  end
end
