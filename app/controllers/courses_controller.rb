# frozen_string_literal: true

class CoursesController < ApplicationController
  def index
    @result = TeachbaseService.new.call(page: 1, per_page: Course::PER_PAGE)
    unless @result.success?
      last_update_time = Course.maximum(:updated_at) || Time.zone.now
      @server_downtime = TimeDifference.between(Time.zone.now, last_update_time).in_hours.round
      flash[:alert] = "В данный момент Teachbase недоступен. Загружена копия от #{last_update_time.to_s(:timedate)}. "\
                      "Teachbase лежит уже #{@server_downtime} часов."
      limit = Course::PER_PAGE
    end
    @courses = Course.where(access_type: 'privy').limit(limit ||= nil).page(params['page']).per(Course::PER_PAGE) # rubocop:disable Lint/UselessAssignment
  end
end
