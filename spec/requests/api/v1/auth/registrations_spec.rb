require 'swagger_helper'
JSON_CONTENT_TYPE = 'application/json'
RSpec.describe 'api/v1/auth/registrations', type: :request do

  
  path '/api/v1/signup' do

    post('create registration') do
      response(200, 'successful') do
        consumes JSON_CONTENT_TYPE
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            user:{
              type: :object,
              properties:{
                email: { type: :string },
                password: { type: :string },
                username: { type: :string}
              }
            }
             
          },
          required: %w[email password username]
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
end
