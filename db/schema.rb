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

ActiveRecord::Schema.define(version: 20130731082435) do

  create_table "alliances", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buildings", force: true do |t|
    t.integer  "typeid"
    t.datetime "lastAction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buildingtypes", force: true do |t|
    t.string   "name"
    t.integer  "level"
    t.integer  "production"
    t.integer  "energyusage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fleets", force: true do |t|
    t.integer  "credit"
    t.integer  "ressource_capacity"
    t.integer  "ore"
    t.integer  "crystal"
    t.float    "storage_factor"
    t.float    "velocity_factor"
    t.integer  "offense"
    t.integer  "defense"
    t.integer  "user_id"
    t.integer  "mission_id"
    t.integer  "departure_time"
    t.integer  "arrival_time"
    t.integer  "start_planet"
    t.integer  "target_planet"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fleets", ["mission_id"], name: "index_fleets_on_mission_id"
  add_index "fleets", ["user_id"], name: "index_fleets_on_user_id"

  create_table "galaxies", force: true do |t|
    t.integer  "x"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missions", force: true do |t|
    t.string   "info_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planets", force: true do |t|
    t.integer  "z"
    t.string   "name"
    t.integer  "special"
    t.float    "size"
    t.integer  "ore"
    t.integer  "maxore"
    t.integer  "crystal"
    t.integer  "maxcrystal"
    t.integer  "energy"
    t.integer  "maxenergy"
    t.integer  "population"
    t.integer  "maxpopulation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ranks", force: true do |t|
    t.string   "name"
    t.boolean  "can_kick"
    t.boolean  "can_massmail"
    t.boolean  "can_edit"
    t.boolean  "can_invite"
    t.boolean  "can_disband"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "alliance_id"
  end

  create_table "ships", force: true do |t|
    t.integer  "construction_time"
    t.integer  "offense"
    t.integer  "defense"
    t.integer  "crystal_cost"
    t.integer  "credit_cost"
    t.integer  "ore_cost"
    t.string   "name"
    t.integer  "velocity"
    t.integer  "crew_capacity"
    t.integer  "ressource_capasity"
    t.integer  "fuel_capacity"
    t.integer  "consumption"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sunsystems", force: true do |t|
    t.integer  "y"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technologies", force: true do |t|
    t.string   "name"
    t.float    "factor"
    t.float    "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technology_requires", force: true do |t|
    t.integer "tech_id"
    t.integer "building_rank"
    t.integer "pre_tech_id"
    t.integer "pre_tech_rank"
  end

  create_table "user_settings", force: true do |t|
    t.float    "increased_income",            default: 1.0
    t.float    "increased_ironproduction",    default: 1.0
    t.float    "increased_energy_efficiency", default: 1.0
    t.float    "increased_movement",          default: 1.0
    t.float    "big_house",                   default: 1.0
    t.float    "increased_research",          default: 1.0
    t.float    "increased_power",             default: 1.0
    t.float    "increased_defense",           default: 1.0
    t.float    "increased_capacity",          default: 1.0
    t.boolean  "hyperspace_technology",       default: false
    t.boolean  "large_cargo_ship",            default: false
    t.boolean  "large_defenseplattform",      default: false
    t.boolean  "destroyer",                   default: false
    t.boolean  "cruiser",                     default: false
    t.boolean  "deathstar",                   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_technologies", force: true do |t|
    t.integer  "rank"
    t.integer  "user_id"
    t.integer  "technology_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",  null: false
    t.string   "encrypted_password",     default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "nickname",                             null: false
    t.integer  "money",                  default: 100
    t.integer  "score",                  default: 0
    t.integer  "alliance_id"
    t.integer  "alliance_rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
