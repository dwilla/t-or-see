Rails.application.routes.draw do
  # Authentication routes
  get "auth" => "authentication#index", as: :auth
  post "check_email" => "authentication#check_email", as: :check_email

  # Devise routes
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # Custom user routes
  resources :users, only: [ :show ]
  resources :events do
    resources :attendees, only: [ :create, :destroy ]
  end
  resources :locations do
    member do
      get :business_hours
    end
  end
  resources :managers, only: [ :create, :destroy ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Root path
  root "home#index"

  resources :home, only: [ :index ] do
    collection do
      get :events_choice
      get :businesses_choice
    end
  end
end
