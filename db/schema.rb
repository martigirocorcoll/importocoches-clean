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

ActiveRecord::Schema.define(version: 2025_08_07_151640) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "titulo"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.string "image"
    t.string "locale"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "phone"
    t.text "comment"
    t.string "mobile_link"
    t.string "price"
    t.string "source"
    t.string "reference_number"
    t.string "page_url"
    t.string "page_title"
    t.bigint "user_id"
    t.text "utm_params"
    t.index ["created_at"], name: "index_contacts_on_created_at"
    t.index ["page_url"], name: "index_contacts_on_page_url"
    t.index ["reference_number"], name: "index_contacts_on_reference_number", unique: true
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "encargos", force: :cascade do |t|
    t.string "nombre"
    t.string "fpago_coche"
    t.string "frecogida"
    t.string "fentrada_and"
    t.string "fcobro_iva"
    t.string "contacto"
    t.string "cantidad_iva"
    t.string "direccion_recog"
    t.string "comentario"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "imported_cars", force: :cascade do |t|
    t.string "brand"
    t.string "model"
    t.integer "year"
    t.integer "mileage"
    t.integer "horsepower"
    t.string "fuel_type"
    t.text "long_description_es"
    t.text "long_description_en"
    t.text "long_description_cat"
    t.text "long_description_fr"
    t.text "ad_image_urls"
    t.text "video_urls"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "precio"
    t.date "imported_date"
    t.string "slug"
    t.index ["slug"], name: "index_imported_cars_on_slug"
  end

  create_table "llamadas", force: :cascade do |t|
    t.string "endpoint"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ip_address"
    t.text "user_agent"
    t.string "referer"
    t.string "session_id"
    t.string "country"
    t.string "request_method"
    t.bigint "user_id"
    t.index ["created_at", "ip_address"], name: "index_llamadas_on_created_at_and_ip"
    t.index ["created_at"], name: "index_llamadas_on_created_at"
    t.index ["ip_address"], name: "index_llamadas_on_ip_address"
    t.index ["referer"], name: "index_llamadas_on_referer"
    t.index ["request_method"], name: "index_llamadas_on_request_method"
    t.index ["session_id"], name: "index_llamadas_on_session_id"
    t.index ["user_agent"], name: "index_llamadas_on_user_agent"
    t.index ["user_id"], name: "index_llamadas_on_user_id"
  end

  create_table "models", force: :cascade do |t|
    t.string "marca"
    t.string "model"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "prices", force: :cascade do |t|
    t.string "marca"
    t.string "modelo"
    t.integer "año_matriculacion"
    t.integer "factor_potencia"
    t.integer "hacienda"
    t.integer "co2"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "fname"
    t.string "lname"
    t.string "telephone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contacts", "users"
  add_foreign_key "llamadas", "users"
end
