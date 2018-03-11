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

ActiveRecord::Schema.define(version: 20180311101224) do

  create_table "builds", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "job_id"
    t.integer "number"
    t.string "url"
    t.timestamp "timestamp"
    t.string "result"
    t.integer "duration"
    t.index ["job_id", "number"], name: "index_builds_on_job_id_and_number", unique: true
    t.index ["job_id"], name: "index_builds_on_job_id"
    t.index ["number"], name: "index_builds_on_number"
    t.index ["result"], name: "index_builds_on_result"
    t.index ["timestamp"], name: "index_builds_on_timestamp"
  end

  create_table "jobs", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "folder"
    t.string "display_name"
    t.string "url"
    t.string "health_score"
    t.string "health_description"
    t.integer "failed_streak"
    t.integer "last_build_number"
    t.timestamp "last_build_timestamp"
    t.string "last_build_result"
    t.index ["failed_streak"], name: "index_jobs_on_failed_streak"
    t.index ["health_score"], name: "index_jobs_on_health_score"
    t.index ["name", "folder"], name: "index_jobs_on_name_and_folder"
    t.index ["name"], name: "index_jobs_on_name"
  end

end
