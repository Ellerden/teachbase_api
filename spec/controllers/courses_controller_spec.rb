# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  let(:courses) { create_list(:course, 3) }

  describe 'GET #index' do
    it 'renders index view' do
      VCR.use_cassette('TeachbaseService/api_response', record: :new_episodes) do
        get :index
        expect(response).to render_template :index
      end
    end
  end
end
