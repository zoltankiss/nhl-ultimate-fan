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

ActiveRecord::Schema[7.0].define(version: 2023_01_08_192027) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "job_data", force: :cascade do |t|
    t.string "job_name"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nhl_games", force: :cascade do |t|
    t.string "link"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "away_team_name"
    t.string "home_team_name"
    t.integer "away_team_id"
    t.integer "home_team_id"
    t.string "game_date"
  end

  create_table "nhl_player_game_stats", id: false, force: :cascade do |t|
    t.string "player_id"
    t.bigint "nhl_game_id"
    t.string "player_name"
    t.string "team_id"
    t.string "team_name"
    t.string "player_age"
    t.string "player_number"
    t.string "player_position"
    t.integer "assists"
    t.integer "goals"
    t.integer "hits"
    t.integer "points"
    t.integer "penalty_minutes"
    t.string "opponent_team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nhl_game_id"], name: "index_nhl_player_game_stats_on_nhl_game_id"
    t.index ["player_id"], name: "index_nhl_player_game_stats_on_player_id", unique: true
  end

end
