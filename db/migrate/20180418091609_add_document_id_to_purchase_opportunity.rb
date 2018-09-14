class AddDocumentIdToPurchaseOpportunity < ActiveRecord::Migration[5.1]
  def change
    add_column :purchase_opportunities, :document_id, :uuid
  end
end
