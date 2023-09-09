require 'swagger_helper'

RSpec.describe 'API v1 Auth Sessions', type: :request do
  
  let(:access_token) { 'Bearer access token' }
  
  # Create a user with a valid session token using FactoryBot

  path '/api/v1/login' do
    post('Create Session upon Login') do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[email password]
          }
        }
      }

      response '200', 'successful' do
        let!(:newuser) { FactoryBot.create(:user) }
        let(:user) do
          {
            user: {
              email: newuser.email, # Use the email of the user created above
              password: newuser.password # Use the password of the user created above
            }
          }
        end

        run_test! do
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response_data[:code]).to eq(200)
          expect(response_data[:message]).to eq('Logged in successfully.')
          
          # Add more expectations here based on your application's response format.
        end
      end

      response '401', 'unauthorized' do
        let(:user) do
          {
            user: {
              email: 'invalid@example.com',
              password: 'invalidpassword'
            }
          }
        end

        run_test! do
          expect(response).to have_http_status(401)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response_data[:error]).to eq('Invalid Email or password.')
          
          # Add more expectations here based on your application's response format.
        end
      end


    end
  end

  path '/api/v1/logout' do
    delete('Delete Session') do
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: 'access_token'

      response '200', 'successful' do

        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end
  
        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        run_test! do
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          response_data = JSON.parse(response.body, symbolize_names: true)
          # Add your specific expectations here based on the expected response data.
        end
      end
    end
  end

  def login(user)
    # Implement your login logic here, e.g., make a POST request to your login endpoint
    # and return the session token
    # Example:
    post '/api/v1/login', params: {
      user: {
        email: user.email,
        password: user.password
      }
    }
    response.headers['Authorization'].split(' ').last
  end


end
