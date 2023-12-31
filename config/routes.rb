Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  root to: proc { [200, {}, ["Auth Service API version1"]] }

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphql", graphql_path: "/graphql#execute"
  end

  post "/graphql", to: "graphql#execute"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[index show] do
        member do
          post "assign_role"
          delete "remove_role"
          post "get_by_email"
        end

        patch "update_username", on: :collection
        post "get_by_email", on: :collection
      end
    end
  end

  scope :api, defaults: { format: :json } do
    scope :v1 do
      devise_for :users, defaults: { format: :json }, path: "", path_names: {
                           sign_in: "login",
                           sign_out: "logout",
                           registration: "signup",
                         },
                         controllers: {
                           sessions: "api/v1/auth/sessions",
                           registrations: "api/v1/auth/registrations",
                         }
    end
  end
end
