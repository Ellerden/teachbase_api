# frozen_string_literal: true

require 'rest-client'

class TeachbaseService
  ROOT_ENDPOINT = 'https://s1.teachbase.ru'

  attr_accessor :errors

  def initialize(client_key = nil, secret_key = nil)
    @errors = []
    @client_key = client_key || ENV['TEACHBASE_CLIENT_KEY']
    @secret_key = secret_key || ENV['TEACHBASE_SECRET_KEY']
    @token = token
  end

  # TeachbaseAPI courses per page (max 100, default 10).
  def call(params = {})
    return self unless success?

    connect(params)
    courses_json = [] || params['loaded_courses']
    while params[:page] <= @total_pages
      courses_json << convert_to_json(@resp.body)
      call(page: params[:page] + 1, per_page: Course::PER_PAGE, loaded_courses: courses_json) unless params[:page] == @total_pages
      break
    end
    save_courses(courses_json.flatten)
    self
  end

  def success?
    !failure?
  end

  private

  def failure?
    @errors.any?
  end

  def connect(params)
    @resp = RestClient.get "#{ROOT_ENDPOINT}/endpoint/v1/course_sessions", {
      'Authorization' => "Bearer #{@token}",
      params: { page: params[:page], per_page: params[:per_page] }
    }
    @total_pages = @resp.headers[:total].to_i / @resp.headers[:per_page].to_i
  rescue RestClient::ExceptionWithResponse => e
    @errors << e.message
  end

  def save_courses(courses)
    courses.map! { |course| course_params(course) }
    Course.upsert_all(courses, unique_by: :course_index)
  end

  def convert_to_json(courses)
    JSON.parse(courses)
  end

  def token
    response = RestClient.post "#{ROOT_ENDPOINT}/oauth/token", {
      grant_type: 'client_credentials',
      client_id: @client_key,
      client_secret: @secret_key
    }
    JSON.parse(response)['access_token']
  rescue RestClient::ExceptionWithResponse => e
    @errors << e.message
  end

  # rubocop:disable Metrics/MethodLength
  def course_params(course)
    {
      course_id: course['course_id'],
      access_type: course['access_type'],
      started_at: course['started_at'],
      finished_at: course['finished_at'],
      apply_url: course['apply_url'],
      owner_name: course['course']['owner_name'],
      name: course['course']['name'],
      thumb_url: course['course']['thumb_url'],
      description: course['course']['description'],
      total_score: course['course']['total_score'],
      total_tasks: course['course']['total_tasks']
    }
  end
  # rubocop:enable Metrics/MethodLength
end
