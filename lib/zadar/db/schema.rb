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

ActiveRecord::Schema.define(version: 20141120222329) do

  create_table "machines", force: true do |t|
    t.string  "name"
    t.string  "os_name"
    t.string  "os_version"
    t.string  "os_type",    default: "linux"
    t.integer "iso_id"
    t.string  "memory"
    t.string  "cpus"
    t.string  "disk_size"
  end

  create_table "projects", force: true do |t|
    t.string  "name"
    t.string  "path"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
    t.string  "name"
    t.string  "login"
    t.string  "admin", default: "f"
    t.integer "uid"
    t.integer "gid"
  end

end
