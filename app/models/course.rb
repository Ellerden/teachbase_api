# frozen_string_literal: true

class Course < ApplicationRecord
  PER_PAGE = 2
  paginates_per PER_PAGE

  validates :course_id, :name, :owner_name, presence: true
end
