class CreateVestingEventTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :vesting_event_templates, id: :uuid do |t|
      t.decimal :quantityPercentage
      t.decimal :strike
      t.date :vestedDate

      t.timestamps
      t.uuid "incentive_sub_program_template_id"
      t.index ["incentive_sub_program_template_id"], name: "incentive_sub_program_template_on_vesting_event_templates"
    end
  end
end
