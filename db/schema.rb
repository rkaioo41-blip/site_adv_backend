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

ActiveRecord::Schema[8.1].define(version: 2026_04_04_155341) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "contatos", force: :cascade do |t|
    t.string "area", null: false
    t.string "assunto"
    t.datetime "created_at", null: false
    t.datetime "data_leitura"
    t.string "email", null: false
    t.string "ip_remetente"
    t.text "mensagem", null: false
    t.string "nome", null: false
    t.string "status", default: "pendente", null: false
    t.string "telefone"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.index ["area"], name: "index_contatos_on_area"
    t.index ["created_at"], name: "index_contatos_on_created_at"
    t.index ["email"], name: "index_contatos_on_email"
    t.index ["status", "created_at"], name: "index_contatos_on_status_created_at"
    t.index ["status"], name: "index_contatos_on_status"
  end
end
