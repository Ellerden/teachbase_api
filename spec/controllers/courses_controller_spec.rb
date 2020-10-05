# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  let(:courses) { create_list(:course, 3) }

  describe 'GET #index' do
    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
