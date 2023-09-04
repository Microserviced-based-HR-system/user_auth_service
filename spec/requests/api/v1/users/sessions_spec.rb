require 'swagger_helper'

RSpec.describe 'api/v1/users/sessions', type: :request do

  let(:Authorization) { "Bearer access token" }

  path '/api/v1/login' do

    post('create session upon login') do
      response(200, 'successful') do
        consumes 'application/json'
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
              email: { type: :string },
              password: { type: :string }
          },
          required: %w[email password]
        }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
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
        consumes 'application/json'

        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string, description: 'access_token'

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

end
