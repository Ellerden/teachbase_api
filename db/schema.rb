# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_201_001_205_959) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'courses', force: :cascade do |t|
    t.integer 'course_id', null: false
    t.string 'name', null: false
    t.string 'owner_name', null: false
    t.string 'apply_url'
    t.string 'access_type'
    t.string 'thumb_url'
    t.string 'description'
    t.integer 'total_score'
    t.integer 'total_tasks'
    t.datetime 'started_at'
    t.datetime 'finished_at'
    t.datetime 'created_at', precision: 6, default: -> { 'CURRENT_TIMESTAMP' }, null: false
    t.datetime 'updated_at', precision: 6, default: -> { 'CURRENT_TIMESTAMP' }, null: false
    t.index %w[course_id access_type apply_url], name: 'course_index', unique: true
  end
end
