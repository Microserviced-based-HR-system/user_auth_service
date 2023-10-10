require "swagger_helper"
JSON_CONTENT_TYPE = "application/json"

RSpec.describe "api/v1/users", type: :request do
  path "/api/v1/users" do
    get("list users") do
      tags "Users"
      consumes "application/json"
      produces "application/json"
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: "Access Token"
      parameter name: :per_page, in: :query, type: :integer, description: "no of items per page", default: 3
      parameter name: :page, in: :query, type: :integer, description: "page no", default: 1

      response 200, "get user list" do
        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end

        let(:Authorization) do
          "Bearer #{@session_token}"
        end
        let(:page) { 1 }
        let(:per_page) { 3 }
        run_test! do
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq("application/json; charset=utf-8")
          response_data = JSON.parse(response.body, symbolize_names: true)
          # Add your specific expectations here based on the expected response data.
        end
      end
    end
  end

  path "/api/v1/users/{id}" do
    get("show user") do
      tags "Users"
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: "Access Token"
      parameter name: "id", in: :path, type: :string, description: "User ID"

      response(200, "successful") do
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
          expect(response.content_type).to eq("application/json; charset=utf-8")
          response_data = JSON.parse(response.body, symbolize_names: true)
          # Add your specific expectations here based on the expected response data.
        end
      end
    end
  end

  path "/api/v1/users/{id}/assign_role" do
    post "Assign a role to a user" do
      tags "Users"
      consumes "application/json"

      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: "Access Token"
      parameter name: :id, in: :path, type: :string

      parameter name: :role, in: :body, schema: {
        type: :object,
        properties: {
          role: { type: :string, default: "employee", enum: User::ROLES },
        },
      }

      response "200", "role assigned" do
        before do
          @hruser = FactoryBot.create(:user)
          @hruser.add_role("hr_manager")
          @session_token = login(@hruser)

          @user = FactoryBot.create(:user)
        end
        let(:Authorization) { "Bearer #{@session_token}" }
        let(:id) { @user.id }

        let(:role) do
          {
            role: "employee",
          }
        end

        run_test! do
          @user.reload # Reload the user to get the updated roles
          expect(response).to have_http_status(200)
          p response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response.content_type).to eq("application/json; charset=utf-8")
          expect(response_data[:data][:roles]).to include("employee")
          expect(@user.has_role?("employee")).to be true # Verify that the role was assigned
        end
      end

      response "401", "forbidden" do
        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end

        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        let(:id) { @user.id }
        let(:role) { "user" } # The role to assign to another user

        run_test! do
          expect(response).to have_http_status(401)
          response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response_data[:error]).to eq("You are not authorized to perform this action.")
          expect(response.content_type).to eq("application/json; charset=utf-8")
        end
      end
    end
  end

  path "/api/v1/users/{id}/remove_role" do
    delete "Delete a role to a user" do
      tags "Users"
      consumes "application/json"

      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: "Access Token"
      parameter name: :id, in: :path, type: :string
      parameter name: :role, in: :body, type: :string, description: "Role to assign", default: "employee"

      response "200", "Remove Role" do
        before do
          @hr_manager = FactoryBot.create(:user)
          @hr_manager.add_role("hr_manager")
          @session_token = login(@hr_manager)

          @user = FactoryBot.create(:user)
          @user.add_role("recuriter")
        end

        let(:id) { @user.id }
        let(:role) do
          {
            role: "recuriter",
          }
        end

        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        run_test! do
          expect(response).to have_http_status(200)
          response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response.content_type).to eq("application/json; charset=utf-8")
          expect(response.content_type).to eq("application/json; charset=utf-8")
          expect(response_data[:data][:roles]).not_to include("recruiter")
          response_data = JSON.parse(response.body, symbolize_names: true)
        end
      end

      response "401", "Forbidden" do
        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end

        let(:id) { @user.id }
        let(:role) { "recruiter" }

        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        run_test! do
          expect(response).to have_http_status(401)
          response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response_data[:error]).to eq("You are not authorized to perform this action.")
          expect(response.content_type).to eq("application/json; charset=utf-8")
        end
      end
    end
  end

  path "/api/v1/users/update_username" do
    patch 'Update a user\'s username' do
      tags "Users"
      consumes "application/json"
      produces "application/json"

      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: "Access Token"
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
        },
      }
      response "200", "Username updated" do
        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end

        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        let(:user) { { username: "new_username" } }

        run_test! do
          # p response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response).to have_http_status(200)
          expect(response.body).to include("Username updated to 'new_username'.")
        end
      end

      response "422", "Validation errors" do
        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end

        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        let(:user) { { username: "" } } # Invalid username

        run_test! do
          expect(response).to have_http_status(422)
          expect(response.body).to include("Username update failed.")
        end
      end
    end
  end

  path "/api/v1/users/get_by_email" do
    post "Get user by email" do
      tags "Users"
      consumes "application/json"
      produces "application/json"

      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string, description: "Access Token"
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
        },
      }
      response "200", "User Found" do
        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end

        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        let(:user) { { email: @user.email } }

        run_test! do
          # p response_data = JSON.parse(response.body, symbolize_names: true)
          expect(response).to have_http_status(200)
        end
      end

      response "404", "User not found by email" do
        before do
          @user = FactoryBot.create(:user)
          @session_token = login(@user)
        end

        let(:Authorization) do
          "Bearer #{@session_token}"
        end

        let(:user) { { email: "" } } # Invalid username

        run_test! do
          expect(response).to have_http_status(404)
          expect(response.body).to include("User not found by email")
        end
      end
    end
  end

  def login(user)
    post "/api/v1/login", params: {
                            user: {
                              email: user.email,
                              password: user.password,
                            },
                          }
    response.headers["Authorization"].split.last
  end
end
