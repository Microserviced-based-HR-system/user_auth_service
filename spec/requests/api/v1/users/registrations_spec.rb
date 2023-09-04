require 'swagger_helper'

RSpec.describe 'api/v1/users/registrations', type: :request do

  path '/api/v1/signup' do

    post('create registration') do
      response(200, 'successful') do
        consumes 'application/json'
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
              email: { type: :string },
              password: { type: :string },
              username: { type: :string}
          },
          required: %w[email password username]
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
end
