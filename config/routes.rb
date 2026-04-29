Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :pick_list_items do
      namespace :candidate do
        resources :citizenships, only: :index
        resources :situations, only: :index
        resources :assignment_statuses, only: :index
        resources :types, only: :index
        resources :adviser_requirements, only: :index
        resources :adviser_eligibilities, only: :index
        resources :consideration_journey_stages, only: :index
        resources :retake_gcse_statuses, only: :index
        resources :gcse_statuses, only: :index
        resources :teacher_training_adviser_subscription_channels, only: :index
        resources :event_subscription_channels, only: :index
        resources :mailing_list_subscription_channels, only: :index
        resources :channels, only: :index
        resources :preferred_education_phases, only: :index
        resources :initial_teacher_training_years, only: :index
      end
    end
    namespace :lookup_items do
      resources :countries, only: :index
      resources :degree_countries, only: :index
      resources :teaching_subjects, only: :index
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "pages#home"

  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
    get "/500", to: "errors#internal_server_error"
  end
end
