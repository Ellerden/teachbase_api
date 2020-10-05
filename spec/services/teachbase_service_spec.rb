# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe TeachbaseService, type: :service do
  describe '#call' do
    it 'gets a response from API' do
      VCR.use_cassette('TeachbaseService/api_response', record: :new_episodes) do
        response = TeachbaseService.new.call(page: 1, per_page: Course::PER_PAGE)
        expect(response.as_json['resp'].code).to eq 200
      end
    end

    it 'populates courses' do
      VCR.use_cassette('TeachbaseService/api_response', record: :new_episodes) do
        expect { TeachbaseService.new.call(page: 1, per_page: Course::PER_PAGE) }.to change(Course, :count)
      end
    end
  end

  describe '#initialize' do
    it 'gets token from API' do
      VCR.use_cassette 'TeachbaseService/token' do
        response = TeachbaseService.new
        expect(response.as_json['token']).to eq '1a936365a4708e00e71de91427beb4156eaaaf984f8b7c2177f01a0884bb033d'
      end
    end
  end

  describe '#success?' do
    it 'returns true if no errors' do
      VCR.use_cassette 'TeachbaseService/token' do
        response = TeachbaseService.new
        expect(response.success?).to be true
      end
    end

    it 'returns false if errors' do
      VCR.use_cassette 'TeachbaseService/no_token' do
        response = TeachbaseService.new(client_key: 'false_key')
        expect(response.success?).to be false
      end
    end
  end
end
