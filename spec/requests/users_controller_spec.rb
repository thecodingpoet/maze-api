require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  describe 'POST #create' do
    let(:user) { build(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:valid_attributes) do
      attributes_for(:user, password_confirmation: user.password)
    end
    let(:invalid_attributes) do
      attributes_for(:user, password_confirmation: "#{user.password}error")
    end

    context 'When request is valid' do 
      before { post '/api/v1/users', params: { user: valid_attributes }.to_json, headers: headers }

      it 'creates new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        json = JSON.parse(response.body)
        expect(json['message']).to match(/User created successfully/)
      end

      it 'returns an authenticated token' do
        json = JSON.parse(response.body)
        expect(json['token']).not_to be_nil
      end
    end

    context 'When request is invalid' do
      before { post '/api/v1/users', params: { user: invalid_attributes }.to_json, headers: headers }

      it 'does not create a new user' do   
        expect(response).to have_http_status(400)
      end

      it 'returns failure message' do
        json = JSON.parse(response.body)
        expect(json['errors']).not_to be_nil
      end
    end
  end

  describe 'POST #login' do
    let!(:user) { create(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:valid_credentials) do
      {
        user: {
          email: user.email,
          password: user.password
        }
      }.to_json
    end
    let(:invalid_credentials) do
      {
        user: {
          email: Faker::Internet.email,
          password: Faker::Internet.password
        }
      }.to_json
    end

    context 'When request is valid' do 
      before { post '/api/v1/users/login', params: valid_credentials, headers: headers }

      it 'returns an authenticated token' do
        json = JSON.parse(response.body)
        expect(json['token']).not_to be_nil
      end

      it 'returns success message' do
        json = JSON.parse(response.body)
        expect(json['message']).to match(/User logged in successfully/)
      end
    end

    context 'When request is invalid' do
      before { post '/api/v1/users/login', params: invalid_credentials, headers: headers }

      it 'returns an error message' do
        json = JSON.parse(response.body)
        expect(json['error']).to match(/Invalid username or password/)
      end
    end
  end
end
