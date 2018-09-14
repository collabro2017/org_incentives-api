class AddCommentToTenant < ActiveRecord::Migration[5.1]
  def change
    add_column :tenants, :comment, :text
  end
end
