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
      before { post '/api/v1/signup', params: { user: valid_attributes }.to_json, headers: headers }

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
      before { post '/api/v1/signup', params: { user: invalid_attributes }.to_json, headers: headers }

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
      before { post '/api/v1/login', params: valid_credentials, headers: headers }

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
      before { post '/api/v1/login', params: invalid_credentials, headers: headers }

      it 'returns an error message' do
        json = JSON.parse(response.body)
        expect(json['errors']['base']).to match(/Invalid username or password/)
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    context 'When user exists' do 
      before { get "/api/v1/users/#{user.id}", headers: valid_headers }

      it 'returns the user details' do  
        json = JSON.parse(response.body)
        expect(json['data']).not_to be_empty
      end
    end

    context 'When user does not exist' do 
      before { get "/api/v1/users/#{user.id + 1}", headers: valid_headers }

      it 'does not return the user details' do  
        json = JSON.parse(response.body)
        expect(json['data']).to be_nil
      end
    end
  end

  describe  'PUT #update' do
    let!(:user) { create(:user_with_interests) }
    let(:valid_user) do
      attributes_for(:user, username: "#{user.username}_test", strengths_attributes: user.strengths, concerns_attributes: user.concerns)
    end

    context 'When user is authorized' do 
      before { put "/api/v1/users/#{user.id}", params: { user: valid_user }.to_json, headers: valid_headers }

      it 'updates the user details' do  
        expect(response).to have_http_status(204)
      end
    end

    context 'When user is not authorized' do 
      before { put "/api/v1/users/#{user.id + 1}", headers: valid_headers }

      it 'returns an error message' do
        json = JSON.parse(response.body)
        expect(json['errors']['base']).to match(/Invalid Request/)
      end

      it 'returns an unauthorized status code' do   
        expect(response).to have_http_status(401)
      end
    end
  end
end
