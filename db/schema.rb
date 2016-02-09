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

ActiveRecord::Schema.define(version: 20160209021444) do

  create_table "assignments", force: :cascade do |t|
    t.integer  "game_id",         null: false
    t.integer  "killer_id",       null: false
    t.integer  "target_id",       null: false
    t.datetime "time_terminated"
    t.boolean  "reverse_killed",  null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "assignments", ["game_id"], name: "index_assignments_on_game_id"

  create_table "games", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "passcode",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "games", ["name"], name: "index_games_on_name", unique: true

  create_table "players", force: :cascade do |t|
    t.integer  "user_id",                       null: false
    t.integer  "game_id",                       null: false
    t.string   "nickname"
    t.boolean  "gamemaker",     default: false, null: false
    t.boolean  "spectator",                     null: false
    t.boolean  "alive",                         null: false
    t.integer  "target_id"
    t.integer  "assassin_id"
    t.string   "kill_code"
    t.datetime "time_of_death"
    t.integer  "points"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id"
  add_index "players", ["user_id", "game_id"], name: "index_players_on_user_id_and_game_id", unique: true
  add_index "players", ["user_id"], name: "index_players_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  add_index "users", ["provider"], name: "index_users_on_provider"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["uid"], name: "index_users_on_uid"

end
