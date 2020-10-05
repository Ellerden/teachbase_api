# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.integer :course_id, null: false
      t.string :name, null: false
      t.string :owner_name, null: false
      t.string :apply_url
      t.string :access_type
      t.string :thumb_url
      t.string :description
      t.integer :total_score
      t.integer :total_tasks
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :courses, %i[course_id access_type apply_url], name: 'course_index', unique: true
  end
end
