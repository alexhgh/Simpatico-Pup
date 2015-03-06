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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150306203921) do

  create_table "breeders", :force => true do |t|
    t.string "name"
    t.string "location"
    t.string "website"
    t.string "kennel"
  end

  create_table "pups", :force => true do |t|
    t.string  "pup_name"
    t.string  "owner_name"
    t.string  "breed_1"
    t.string  "breed_2"
    t.integer "breeder_responsibility"
    t.integer "overall_health"
    t.integer "trainability"
    t.integer "social_behavior"
    t.integer "energy_level"
    t.integer "simpatico_rating"
    t.text    "comments"
    t.integer "breeder_id"
  end

end