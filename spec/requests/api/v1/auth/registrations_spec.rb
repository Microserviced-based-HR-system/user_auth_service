# require 'swagger_helper'

# RSpec.describe 'API v1 Auth Registrations', type: :request do
#   # let(:json_content_type) { 'application/json' }

#   path '/api/v1/signup' do
#     post('Create Registration') do
#       consumes 'application/json'
#       parameter name: :user, in: :body, schema: {
#         type: :object,
#         properties: {
#           user: {
#             type: :object,
#             properties: {
#               email: { type: :string },
#               password: { type: :string },
#               username: { type: :string }
#             },
#             required: %w[email password username]
#           }
#         }
#       }

#       # response '422', 'validation error' do
#       response '200', 'successful' do
#         let(:user) do
#           {
#             user: {
#               email: 'test@example.com',
#               password: 'password123',
#               username: 'testuser'
#             }
#           }
#         end

#         run_test! do

#           expect(response).to have_http_status(200)
#           expect(response.content_type).to eq('application/json; charset=utf-8')
#           response_data = JSON.parse(response.body, symbolize_names: true)
#           expect(response_data).to include(user: hash_including(email: 'test@example.com', username: 'testuser'))

#           # expect(response).to have_http_status(422)
#           # expect(response.content_type).to eq('application/json; charset=utf-8')
#           # response_data = JSON.parse(response.body, symbolize_names: true)
#           # expect(response_data).to include(
#           #   message: a_string_matching(/Email can't be blank/),
#           #   message: a_string_matching(/Password can't be blank/),
#           #   message: a_string_matching(/Username can't be blank/),
#           #   message: a_string_matching(/Username is too short/),
#           #   message: a_string_matching(/Password must be at least 6 characters long/)
#           # )
#         end
#       end
#     end
#   end
# end
require 'swagger_helper'

RSpec.describe 'API v1 Auth Registrations', type: :request do
  path '/api/v1/signup' do
    post('Create Registration') do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              username: { type: :string }
            },
            required: %w[email password username]
          }
        }
      }

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
    end
  end
end
