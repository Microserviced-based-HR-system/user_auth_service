require 'swagger_helper'
JSON_CONTENT_TYPE = 'application/json'

RSpec.describe 'api/v1/auth/sessions', type: :request do

  let(:Authorization) { "Bearer access token" }

  path '/api/v1/login' do

    post('create session upon login') do
      response(200, 'successful') do
        consumes JSON_CONTENT_TYPE
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            user:{
              type: :object,
              properties:{
                email: { type: :string },
                password: { type: :string }
              }
            } 
          },
          required: %w[email password]
        }
        after do |example|
          example.metadata[:response][:content] = {
            JSON_CONTENT_TYPE => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/logout' do

    delete('delete session') do
      response(200, 'successful') do
        consumes JSON_CONTENT_TYPE

        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string, description: 'access_token'

        after do |example|
          example.metadata[:response][:content] = {
            JSON_CONTENT_TYPE => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

end
