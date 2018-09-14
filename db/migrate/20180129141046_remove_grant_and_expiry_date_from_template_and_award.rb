class RemoveGrantAndExpiryDateFromTemplateAndAward < ActiveRecord::Migration[5.1]
  def change
    remove_column :awards, :grantDate
    remove_column :awards, :expiryDate

    remove_column :incentive_sub_program_templates, :grantDate
    remove_column :incentive_sub_program_templates, :expiryDate
  end
end
