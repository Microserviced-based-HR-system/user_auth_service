require 'swagger_helper'

RSpec.describe 'API v1 Auth Registrations', type: :request do
  path '/api/v1/signup' do
    post('Create Registration') do
      tags 'Authentication'
      consumes 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string , default: "employee@email.com"},
              password: { type: :string , default: "abcABC1"},
              username: { type: :string , default: "emp1"}
            },
            required: %w[email password username]
          },
          role: {type: :string, default: "employee"}
        }
      }

      # parameter name: :role, in: :body, type: :string, description: 'Role'

      response '200', 'successful' do
        let(:user_attributes) { FactoryBot.attributes_for(:user) }
        let(:user) { { user: user_attributes } }


        run_test! do

          # puts response.body 
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response_data[:code]).to eq(200)
          expect(response_data[:message]).to eq('Signed up successfully.')
          expect(response_data[:data][:email]).to eq(user_attributes[:email])
          expect(response_data[:data][:username]).to eq(user_attributes[:username])
        end 
      end

      response '422', 'unprocessable entity' do
        let(:user_attributes) { FactoryBot.attributes_for(:user, email: nil) } # Simulating validation error
        let(:user) { { user: user_attributes } }

        run_test! do
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response_data[:message]).to include("User couldn't be created successfully")
          expect(response_data[:message]).to include("Email can't be blank")
        end
      end

      response '422', 'unprocessable entity - custom validation error' do
        let(:user_attributes) { FactoryBot.attributes_for(:user, username: 'tt') } # Simulating custom validation error
        let(:user) { { user: user_attributes } }

        run_test! do
          expect(response).to have_http_status(422)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response_data[:message]).to include("User couldn't be created successfully")
          expect(response_data[:message]).to include("User couldn't be created successfully. Username is too short (minimum is 3 characters)")
        end
      end

    end
  end
end
