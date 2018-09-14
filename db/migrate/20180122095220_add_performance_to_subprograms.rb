class AddPerformanceToSubprograms < ActiveRecord::Migration[5.1]
  def change
    add_column :incentive_sub_programs, :performance, :boolean, :default => false
  end
end
