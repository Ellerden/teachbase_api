# frozen_string_literal: true

class Course < ApplicationRecord
  PER_PAGE = 3
  paginates_per PER_PAGE

  validates :course_id, :name, :owner_name, presence: true
end
