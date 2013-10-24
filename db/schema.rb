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

ActiveRecord::Schema.define(version: 20131015015744) do

  create_table "actors", force: true do |t|
    t.string   "name"
    t.integer  "external_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
  end

  create_table "genres", force: true do |t|
    t.string   "name"
    t.integer  "external_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "external_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "budget"
    t.string   "picture"
    t.datetime "release_date"
  end

  create_table "parts", force: true do |t|
    t.integer  "movie_id"
    t.integer  "actor_id"
    t.string   "character"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "movie_id"
    t.integer  "genre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
