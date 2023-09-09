require 'swagger_helper'
JSON_CONTENT_TYPE = 'application/json'

RSpec.describe 'api/v1/users', type: :request do
  

  path '/api/v1/users' do
    get('list users') do
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: 'Access Token'
      

      response 200, 'get user list' do

        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end
  
        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        # schema type: :array, items: {
        #   type: :object,
        #   properties: {
        #     users: {
        #       type: :array,
        #       items: {'$ref' => '#/components/schemas/user'}
        #     }
        #   },
        
        # }

        run_test! do
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          response_data = JSON.parse(response.body, symbolize_names: true)
          # Add your specific expectations here based on the expected response data.
        end

      end
    end
  end
  
  path '/api/v1/users/{id}' do
    get('show user') do
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: 'Access Token'
      parameter name: 'id', in: :path, type: :string, description: 'User ID'

      response(200, 'successful') do
        
        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end
  
        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        let(:id) { @user.id }

        
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