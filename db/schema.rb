# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_24_112018) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_agencies_on_company_id"
  end

  create_table "checklists", force: :cascade do |t|
    t.string "name"
    t.boolean "is_planned", default: true
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logo_url"
    t.bigint "location_type_id"
    t.interval "recurrence"
    t.index ["company_id"], name: "index_checklists_on_company_id"
    t.index ["location_type_id"], name: "index_checklists_on_location_type_id"
  end

  create_table "checkpoints", force: :cascade do |t|
    t.string "question", null: false
    t.string "description"
    t.bigint "checklist_id"
    t.bigint "issue_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checklist_id"], name: "index_checkpoints_on_checklist_id"
    t.index ["issue_type_id"], name: "index_checkpoints_on_issue_type_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "logo_url"
    t.string "logo_base64"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "issue_reports", force: :cascade do |t|
    t.string "message", null: false
    t.integer "priority", default: 0
    t.bigint "company_id"
    t.bigint "place_id"
    t.bigint "author_id"
    t.bigint "issue_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.bigint "visit_report_id"
    t.bigint "checkpoint_id"
    t.datetime "pending_timestamp"
    t.datetime "ongoing_timestamp"
    t.datetime "done_timestamp"
    t.datetime "canceled_timestamp"
    t.jsonb "imgs"
    t.bigint "spot_id"
    t.jsonb "talks", default: []
    t.index ["author_id"], name: "index_issue_reports_on_author_id"
    t.index ["checkpoint_id"], name: "index_issue_reports_on_checkpoint_id"
    t.index ["company_id"], name: "index_issue_reports_on_company_id"
    t.index ["issue_type_id"], name: "index_issue_reports_on_issue_type_id"
    t.index ["place_id"], name: "index_issue_reports_on_place_id"
    t.index ["spot_id"], name: "index_issue_reports_on_spot_id"
    t.index ["visit_report_id"], name: "index_issue_reports_on_visit_report_id"
  end

  create_table "issue_types", force: :cascade do |t|
    t.string "name"
    t.string "logo_url"
    t.bigint "company_id"
    t.bigint "location_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_issue_types_on_company_id"
    t.index ["location_type_id"], name: "index_issue_types_on_location_type_id"
  end

  create_table "location_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "logo_url"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nature", default: 0, null: false
    t.index ["company_id"], name: "index_location_types_on_company_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "company_id"
    t.bigint "residence_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "zip", default: "", null: false
    t.string "city", default: "", null: false
    t.string "country", default: "", null: false
    t.integer "street_number"
    t.string "street_name"
    t.index ["company_id"], name: "index_places_on_company_id"
    t.index ["residence_id"], name: "index_places_on_residence_id"
  end

  create_table "places_sectors", id: false, force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.bigint "place_id", null: false
    t.index ["place_id", "sector_id"], name: "index_places_sectors_on_place_id_and_sector_id"
    t.index ["sector_id", "place_id"], name: "index_places_sectors_on_sector_id_and_place_id"
  end

  create_table "residences", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "company_id"
    t.bigint "agency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_residences_on_agency_id"
    t.index ["company_id"], name: "index_residences_on_company_id"
  end

  create_table "roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sector_id"
    t.index ["sector_id"], name: "index_roles_on_sector_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_sectors_on_company_id"
  end

  create_table "spots", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "location_type_id"
    t.bigint "place_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_type_id"], name: "index_spots_on_location_type_id"
    t.index ["place_id"], name: "index_spots_on_place_id"
  end

  create_table "tmp_files", force: :cascade do |t|
    t.binary "file_data"
    t.string "filename"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "code"
    t.string "fname", null: false
    t.string "lname", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "one_time_password_digest"
    t.string "status", default: "1", null: false
    t.jsonb "notifications", default: []
    t.jsonb "recipients", default: []
    t.boolean "email_notifications_activated", default: true
    t.boolean "can_close_issue_reports", default: false
    t.jsonb "hardware", default: {}
    t.datetime "last_connection_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.integer "roles_count"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "visit_reports", force: :cascade do |t|
    t.bigint "visit_schedule_id"
    t.bigint "author_id"
    t.jsonb "checkpoints"
    t.integer "issue_reports_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_visit_reports_on_author_id"
    t.index ["visit_schedule_id"], name: "index_visit_reports_on_visit_schedule_id"
  end

  create_table "visit_schedules", force: :cascade do |t|
    t.date "due_at"
    t.bigint "place_id"
    t.bigint "checklist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checklist_id"], name: "index_visit_schedules_on_checklist_id"
    t.index ["place_id"], name: "index_visit_schedules_on_place_id"
  end

  add_foreign_key "agencies", "companies"
  add_foreign_key "checklists", "companies"
  add_foreign_key "checklists", "location_types"
  add_foreign_key "checkpoints", "checklists"
  add_foreign_key "checkpoints", "issue_types"
  add_foreign_key "issue_reports", "checkpoints"
  add_foreign_key "issue_reports", "companies"
  add_foreign_key "issue_reports", "issue_types"
  add_foreign_key "issue_reports", "places"
  add_foreign_key "issue_reports", "spots"
  add_foreign_key "issue_reports", "users", column: "author_id"
  add_foreign_key "issue_reports", "visit_reports"
  add_foreign_key "issue_types", "companies"
  add_foreign_key "issue_types", "location_types"
  add_foreign_key "location_types", "companies"
  add_foreign_key "places", "companies"
  add_foreign_key "places", "residences"
  add_foreign_key "residences", "agencies"
  add_foreign_key "residences", "companies"
  add_foreign_key "roles", "sectors"
  add_foreign_key "roles", "users"
  add_foreign_key "sectors", "companies"
  add_foreign_key "spots", "location_types"
  add_foreign_key "spots", "places"
  add_foreign_key "users", "companies"
  add_foreign_key "visit_reports", "users", column: "author_id"
  add_foreign_key "visit_reports", "visit_schedules"
  add_foreign_key "visit_schedules", "checklists"
  add_foreign_key "visit_schedules", "places"
end
