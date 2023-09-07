require 'swagger_helper'
JSON_CONTENT_TYPE = 'application/json'

RSpec.describe 'api/v1/users', type: :request do
  
  let(:id) { '123' }


  path '/api/v1/users' do
    get('list users') do
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: 'Access Token'
      

      response 200, 'get user list' do
        let(:Authorization) do
          "Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI2OWQ5YTI2NS1lY2QyLTQ1Y2UtYmNkMi1lOTBjZDg3ZmJjZWYiLCJzdWIiOiI4MTViYTM3YS02ZTU5LTQ5MWQtYTY1Yy1iOTYyMWU3Y2FhYjUiLCJzY3AiOiJ1c2VyIiwiYXVkIjpudWxsLCJpYXQiOjE2OTQwNjA4MjUsImV4cCI6MTY5NTM1NjgyNX0.SrDNIZmrNeWJLqnJHGP7x3OEtwYUXLiSe25jd6ONsEs"
        end
        schema type: :array, items: {
          type: :object,
          properties: {
            users: {
              type: :array,
              items: {'$ref' => '#/components/schemas/user'}
            }
          },
        
        }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { -1 }
 
        run_test!
      end
    end
  end

  # path '/api/v1/users/{id}' do
  #   get('show user') do
  #     security [Bearer: {}]
  #     parameter name: :Authorization, in: :header, type: :string, description: 'Access Token'
  #     parameter name: 'id', in: :path, type: :string, description: 'User ID'

  #     response(200, 'successful') do
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end
end