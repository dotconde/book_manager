Rails.application.routes.draw do
  get "health", to: "rails/health#show", as: :rails_health_check

  devise_for :users, path: "api/v1", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
    sessions: "api/v1/auth/sessions",
    registrations: "api/v1/auth/registrations"
  }

  namespace :api do
    namespace :v1 do
      resources :books, only: [:index, :show, :create, :update, :destroy]

      resources :borrowings, only: [:index, :create] do
        member do
          patch :return
        end
      end

      get "dashboard", to: "dashboard#index"
      get "me", to: "users#me"
    end
  end
end
