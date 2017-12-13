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

ActiveRecord::Schema.define(version: 20171115200450) do
  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username", limit: 200
    t.string "email", limit: 254
    t.string "password", limit: 60
    t.string "nonce", limit: 36
    t.integer "activated", limit: 1, default: 0, unsigned: true
    t.string "activation_code", limit: 36
    t.string "password_reset", limit: 36
    t.integer "locked", limit: 1, default: 0, unsigned: true
    t.string "role", limit: 9, default: "user"
  end
end
