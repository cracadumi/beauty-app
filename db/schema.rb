# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160620123936) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "street"
    t.integer  "postcode"
    t.string   "city"
    t.string   "state"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "country"
  end

  add_index "addresses", ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", using: :btree

  create_table "availabilities", force: :cascade do |t|
    t.integer  "settings_beautician_id"
    t.integer  "day"
    t.time     "starts_at",              default: '2000-01-01 09:00:00', null: false
    t.time     "ends_at",                default: '2000-01-01 17:00:00', null: false
    t.boolean  "working_day",            default: true,                  null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  add_index "availabilities", ["settings_beautician_id"], name: "index_availabilities_on_settings_beautician_id", using: :btree

  create_table "bookings", force: :cascade do |t|
    t.integer  "status",                                             default: 0,     null: false
    t.integer  "user_id"
    t.integer  "beautician_id"
    t.datetime "datetime_at"
    t.decimal  "pay_to_beautician",          precision: 8, scale: 2
    t.decimal  "total_price",                precision: 8, scale: 2
    t.text     "notes"
    t.text     "unavailability_explanation"
    t.boolean  "checked_in",                                         default: false, null: false
    t.datetime "expires_at"
    t.boolean  "instant",                                            default: false, null: false
    t.datetime "reschedule_at"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.string   "items"
  end

  add_index "bookings", ["beautician_id"], name: "index_bookings_on_beautician_id", using: :btree
  add_index "bookings", ["user_id"], name: "index_bookings_on_user_id", using: :btree

  create_table "bookings_services", force: :cascade do |t|
    t.integer "booking_id"
    t.integer "service_id"
  end

  add_index "bookings_services", ["booking_id"], name: "index_bookings_services_on_booking_id", using: :btree
  add_index "bookings_services", ["service_id"], name: "index_bookings_services_on_service_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.string   "country"
    t.string   "flag_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "user_id"
    t.integer  "payment_method_id"
    t.datetime "paid_at"
    t.decimal  "amount",            precision: 8, scale: 2
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "payments", ["booking_id"], name: "index_payments_on_booking_id", using: :btree
  add_index "payments", ["payment_method_id"], name: "index_payments_on_payment_method_id", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.integer  "picturable_id"
    t.string   "picturable_type"
    t.string   "title"
    t.text     "description"
    t.string   "picture_url"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pictures", ["picturable_type", "picturable_id"], name: "index_pictures_on_picturable_type_and_picturable_id", using: :btree

  create_table "refunds", force: :cascade do |t|
    t.integer  "booking_id"
    t.datetime "refunded_at"
    t.decimal  "amount_refunded_to_performer", precision: 8, scale: 2
    t.decimal  "amount_refunded_to_customer",  precision: 8, scale: 2
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "refunds", ["booking_id"], name: "index_refunds_on_booking_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "user_id"
    t.integer  "rating",     default: 1,    null: false
    t.text     "comment"
    t.integer  "author_id"
    t.boolean  "visible",    default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "reviews", ["author_id"], name: "index_reviews_on_author_id", using: :btree
  add_index "reviews", ["booking_id"], name: "index_reviews_on_booking_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sub_category_id"
    t.decimal  "price",           precision: 8, scale: 2
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "services", ["sub_category_id"], name: "index_services_on_sub_category_id", using: :btree
  add_index "services", ["user_id"], name: "index_services_on_user_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "settings_beauticians", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "instant_booking", default: false, null: false
    t.boolean  "advance_booking", default: false, null: false
    t.boolean  "mobile",          default: false, null: false
    t.boolean  "office",          default: false, null: false
    t.string   "profession"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "settings_beauticians", ["user_id"], name: "index_settings_beauticians_on_user_id", using: :btree

  create_table "sub_categories", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "sub_categories", ["category_id"], name: "index_sub_categories_on_category_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.string   "surname"
    t.string   "username"
    t.integer  "role",                   default: 0,     null: false
    t.integer  "sex",                    default: 3,     null: false
    t.text     "bio"
    t.string   "phone_number"
    t.date     "dob_on"
    t.string   "profile_picture"
    t.boolean  "active",                 default: false, null: false
    t.boolean  "archived",               default: false, null: false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "rating",                 default: 0,     null: false
    t.string   "facebook_id"
    t.integer  "language_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
