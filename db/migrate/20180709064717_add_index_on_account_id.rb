class AddIndexOnAccountId < ActiveRecord::Migration[5.1]
  def change
    add_index :employees, :account_id
  end
end
