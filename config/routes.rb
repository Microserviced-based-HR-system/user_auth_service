Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphql', graphql_path: '/graphql#execute'
  end

  post "/graphql", to: "graphql#execute"


  scope :api, defaults: { format: :json } do
    scope :v1 do

      resources :users, only: %i[index show] do
        member do
          post 'assign_role'
          delete 'remove_role'
        end

        patch 'update_username', on: :collection
        
      end
      
      devise_for :users, defaults: { format: :json }, path: '', path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'signup'
      },
      controllers: {
        sessions: 'api/v1/auth/sessions',
        registrations: 'api/v1/auth/registrations'
      }
    end
  end


end
