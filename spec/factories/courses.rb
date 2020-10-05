# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    sequence(:course_id) { |n| n }
    sequence(:name) { |n| "CourseName#{n}" }
    access_type { 'open' }
    owner_name { 'Tony Robbins' }
  end
end
