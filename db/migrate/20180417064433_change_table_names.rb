class ChangeTableNames < ActiveRecord::Migration[5.1]
  def change
    rename_table :purchase_config, :purchase_configs
    rename_table :purchase_opportunity, :purchase_opportunities
  end
end
