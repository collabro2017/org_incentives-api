# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180822063526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "pgcrypto"

  create_table "awards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "employee_id", null: false
    t.uuid "incentive_sub_program_id", null: false
    t.index ["employee_id"], name: "index_employee_id_on_awards"
    t.index ["incentive_sub_program_id"], name: "index_incentive_sub_program_on_awards"
  end

  create_table "configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.json "texts", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "tenant_id"
    t.index ["tenant_id"], name: "index_tenant_id_on_configs"
  end

  create_table "content_templates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "template_type", null: false
    t.string "content_type", null: false
    t.string "raw_content", null: false
    t.uuid "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "description"
    t.index ["tenant_id"], name: "index_tenant_id_on_contents"
  end

  create_table "countries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "countryName"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dividends", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tenant_id"
    t.date "dividend_date"
    t.decimal "dividend_per_share"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_tenant_id_on_dividends"
  end

  create_table "documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "file_name"
    t.uuid "tenant_id"
    t.string "bucket_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.text "message_header"
    t.text "message_body"
    t.text "document_header"
    t.index ["tenant_id"], name: "index_tenant_id_on_documents"
  end

  create_table "employee_documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "is_read_and_accepted"
    t.boolean "requires_acceptance"
    t.uuid "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "document_id"
    t.datetime "accepted_at"
    t.text "message_header"
    t.text "message_body"
    t.index ["document_id"], name: "index_employee_documents_on_document_id"
    t.index ["employee_id"], name: "index_employee_id_on_employee_documents"
  end

  create_table "employees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "firstName"
    t.string "lastName"
    t.string "email"
    t.string "entity_id"
    t.string "residence"
    t.string "account_id"
    t.uuid "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "insider", default: false
    t.date "termination_date"
    t.decimal "soc_sec"
    t.string "internal_identification"
    t.index ["account_id"], name: "index_employees_on_account_id"
    t.index ["tenant_id"], name: "index_employees_on_tenant_id"
  end

  create_table "entities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "identification"
    t.string "countryCode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "tenant_id"
    t.decimal "soc_sec"
    t.index ["tenant_id"], name: "index_entities_on_tenant_id"
  end

  create_table "exercise_order_lines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "vesting_event_id"
    t.integer "exercise_quantity"
    t.uuid "exercise_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_order_id"], name: "index_exercise_order_id_on_exercise_order_line"
  end

  create_table "exercise_orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status"
    t.string "exerciseType"
    t.uuid "tenant_id"
    t.uuid "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vps_account"
    t.uuid "order_id"
    t.text "bank_account"
    t.index ["employee_id"], name: "index_employee_id_on_exercise_orders"
    t.index ["tenant_id"], name: "index_tenant_id_on_exercise_orders"
  end

  create_table "exercise_windows", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "startTime", null: false
    t.datetime "endTime", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "tenant_id"
    t.datetime "payment_deadline"
    t.index ["tenant_id"], name: "index_tenant_id_on_exercise_windows"
  end

  create_table "features", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "exercise", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "tenant_id", null: false
    t.boolean "documents"
    t.boolean "purchase"
    t.index ["tenant_id"], name: "index_features_on_tenant_id", unique: true
    t.index ["tenant_id"], name: "index_tenant_id_on_features"
  end

  create_table "incentive_programs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.date "startDate"
    t.date "endDate"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "tenant_id"
    t.index ["tenant_id"], name: "index_incentive_programs_on_tenant_id"
  end

  create_table "incentive_sub_program_templates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.json "vesting"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "incentive_sub_program_id"
    t.index ["incentive_sub_program_id"], name: "index_incentive_sub_program_template_on_incentive_sub_program"
  end

  create_table "incentive_sub_programs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "instrumentTypeId"
    t.string "settlementTypeId"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "incentive_program_id"
    t.boolean "performance", default: false
    t.index ["incentive_program_id"], name: "index_incentive_sub_programs_on_incentive_program_id"
  end

  create_table "instrument_types", id: :string, force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mobility_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "employee_id"
    t.uuid "entity_id"
    t.date "from_date"
    t.date "to_date"
    t.decimal "override_entity_soc_sec"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_mobility_entries_on_employee_id"
    t.index ["entity_id"], name: "index_mobility_entries_on_entity_id"
    t.index ["from_date"], name: "index_mobility_entries_on_from_date"
    t.index ["to_date"], name: "index_mobility_entries_on_to_date"
  end

  create_table "order_documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id", null: false
    t.uuid "document_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_document_id_on_order_documents"
    t.index ["order_id"], name: "index_order_id_on_order_documents"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "order_type", null: false
    t.string "status", null: false
    t.uuid "tenant_id", null: false
    t.uuid "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "window_id"
    t.index ["employee_id"], name: "index_employee_id_on_orders"
    t.index ["tenant_id"], name: "index_tenant_id_on_orders"
    t.index ["window_id"], name: "index_orders_on_window_id"
  end

  create_table "purchase_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "incentive_sub_program_id", null: false
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "window_id"
    t.boolean "require_share_depository", default: false
    t.index ["incentive_sub_program_id"], name: "index_incentive_sub_program_id_on_purchase_config"
    t.index ["window_id"], name: "index_purchase_configs_on_window_id"
  end

  create_table "purchase_opportunities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "maximumAmount"
    t.integer "purchasedAmount", default: 0, null: false
    t.uuid "purchase_config_id", null: false
    t.uuid "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "document_id"
    t.index ["employee_id"], name: "index_employee_id_on_purchase_opportunity"
    t.index ["purchase_config_id"], name: "index_purchase_config_id_on_purchase_opportunity"
  end

  create_table "purchase_orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "purchase_amount", null: false
    t.uuid "order_id", null: false
    t.uuid "purchase_opportunity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "instrument_type"
    t.text "share_depository_account"
    t.index ["order_id"], name: "index_order_id_on_purchase_orders"
    t.index ["purchase_opportunity_id"], name: "index_purchase_opportunity_id_on_purchase_orders"
  end

  create_table "settlement_types", id: :string, force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_prices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "date", null: false
    t.decimal "price", null: false
    t.boolean "manual", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "tenant_id", null: false
    t.string "message"
    t.index ["date"], name: "index_stock_prices_on_date"
    t.index ["tenant_id"], name: "index_tenant_id_on_stock_prices"
  end

  create_table "tenants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logo_url"
    t.string "bank_account_number"
    t.string "bic_number"
    t.string "iban_number"
    t.string "payment_address"
    t.string "currency_code", limit: 3, default: "NOK"
    t.text "comment"
  end

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "vesting_event_id"
    t.string "transaction_type"
    t.date "transaction_date"
    t.integer "termination_quantity"
    t.date "termination_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "strike"
    t.date "grant_date"
    t.date "vested_date"
    t.date "expiry_date"
    t.decimal "purchase_price"
    t.integer "quantity"
    t.decimal "fair_value"
    t.text "account_id"
    t.index ["transaction_date"], name: "index_transactions_on_transaction_date"
    t.index ["vesting_event_id"], name: "index_vesting_event_id_on_transactions"
  end

  create_table "vesting_event_templates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "quantityPercentage"
    t.decimal "strike"
    t.date "vestedDate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "incentive_sub_program_template_id"
    t.date "grant_date"
    t.date "expiry_date"
    t.decimal "purchase_price"
    t.index ["incentive_sub_program_template_id"], name: "incentive_sub_program_template_on_vesting_event_templates"
  end

  create_table "vesting_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "award_id", null: false
    t.date "vestedDate", null: false
    t.integer "quantity", null: false
    t.decimal "strike", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "exercisedQuantity", default: 0
    t.date "grant_date"
    t.date "expiry_date"
    t.decimal "purchase_price"
    t.boolean "is_dividend", default: false, null: false
    t.uuid "dividend_source_vesting_event_id"
    t.index ["award_id"], name: "index_vesting_events_on_award_id"
    t.index ["dividend_source_vesting_event_id"], name: "index_vesting_events_on_dividend_source_vesting_event_id"
  end

  create_table "window_employee_restrictions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "employee_id"
    t.uuid "window_restriction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_window_employee_restrictions_on_employee_id"
    t.index ["window_restriction_id"], name: "index_window_employee_restrictions_on_window_restriction_id"
  end

  create_table "window_restrictions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "employee_restriction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "window_id"
  end

  create_table "windows", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tenant_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "payment_deadline"
    t.string "window_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "allowed_exercise_types", default: ["EXERCISE_AND_SELL", "EXERCISE_AND_SELL_TO_COVER", "EXERCISE_AND_HOLD"], array: true
    t.boolean "require_bank_account", default: true, null: false
    t.boolean "require_share_depository", default: true, null: false
    t.decimal "commission_percentage"
    t.index ["tenant_id"], name: "index_tenant_id_on_windows"
  end

end
