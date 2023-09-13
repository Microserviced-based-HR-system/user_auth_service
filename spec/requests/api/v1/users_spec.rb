require 'swagger_helper'
JSON_CONTENT_TYPE = 'application/json'

RSpec.describe 'api/v1/users', type: :request do
  

  path '/api/v1/users' do
    get('list users') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: 'Access Token'
      parameter name: :per_page, in: :query, type: :integer, description: 'no of items per page', default: 3
      parameter name: :page, in: :query, type: :integer, description: 'page no', default: 1

      response 200, 'get user list' do

        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end
  
        let(:Authorization) do
          "Bearer #{@session_token}"
        end
        let(:page) { 1}
        let(:per_page) { 3 }
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
      tags 'Users'
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


  path '/api/v1/users/{id}/assign_role' do
    post 'Assign a role to a user' do
      tags 'Users'
      consumes 'application/json'

      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: 'Access Token'
      parameter name: :id, in: :path, type: :string

      parameter name: :role, in: :body, schema: {
        type: :object,
        properties: {
          role: {type: :string}
        }
      }

      response '200', 'role assigned' do
        before do
          @user = FactoryBot.create(:user)
          @user.add_role("hr_manager")
          @session_token = login(@user)
        end
  
        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        let(:id) { @user.id }
        let(:role) { 'hr_manager' }

        run_test! do
          expect(response).to have_http_status(200)
          p response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response_data[:user][:roles]).to include('hr_manager')
          response_data = JSON.parse(response.body, symbolize_names: true)
        end
      end

      response '422', 'forbidden' do
        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end
  
        let(:Authorization) do
          "Bearer #{@session_token}"
        end
  
        let(:id) { @user.id }
        let(:role) { 'user' } # The role to assign to another user
  
        run_test! do
          expect(response).to have_http_status(422)
          response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response_data[:error]).to eq('Role assignment failed.')
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

    end
  end


  path '/api/v1/users/{id}/remove_role' do
    delete 'Delete a role to a user' do
      tags 'Users'
      consumes 'application/json'

      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: 'Access Token'
      parameter name: :id, in: :path, type: :string
      parameter name: :role, in: :body, schema: {
        type: :object,
        properties: {
          role: {type: :string}
        }
      }

      response '200', 'Remove Role' do
        before do
          @hr_manager = FactoryBot.create(:user)
          @hr_manager.add_role("hr_manager")
          @session_token = login(@hr_manager)

          @user = FactoryBot.create(:user)
          @user.add_role("recuriter")
        end


        let(:id) { @user.id }
        let(:role) { "recuriter" }

        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        run_test! do
          expect(response).to have_http_status(200)
          p response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response_data[:user][:roles]).not_to include('recruiter')
          response_data = JSON.parse(response.body, symbolize_names: true)
        end
      end

      response '422', 'Forbidden' do
        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end
  
        let(:id) { @user.id }
        let(:role) { 'recruiter' }
  
        let(:Authorization) do
          "Bearer #{@session_token}"
        end
  
        run_test! do
          expect(response).to have_http_status(422)
          p response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response_data[:error]).to eq('Role removal failed.')
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
      
    end
  end


  def login(user)
    post '/api/v1/login', params: {
      user: {
        email: user.email,
        password: user.password
      }
    }
    response.headers['Authorization'].split(' ').last
  end

end