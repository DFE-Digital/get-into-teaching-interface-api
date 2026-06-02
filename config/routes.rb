Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :teacher_training_adviser do
      resources :candidates, only: :create
    end

    resource :privacy_policies, only: [] do
      resource :latest, only: :show, module: :privacy_policies, controller: :latest
    end
    resources :privacy_policies, only: :show

    resources :callback_booking_quotas, only: :index
    namespace :lookup_items do
      resources :countries, only: :index
      resources :degree_countries, only: :index
      resources :teaching_subjects, only: :index
    end
    namespace :pick_list_items do
      namespace :candidate do
        resources :adviser_eligibilities, only: :index
        resources :adviser_requirements, only: :index
        resources :assignment_statuses, only: :index
        resources :channels, only: :index
        resources :citizenships, only: :index
        resources :consideration_journey_stages, only: :index
        resources :event_subscription_channels, only: :index
        resources :gcse_statuses, only: :index
        resources :has_qualified_teacher_statuses, only: :index
        resources :initial_teacher_training_years, only: :index
        resources :locations, only: :index
        resources :mailing_list_subscription_channels, only: :index
        resources :preferred_education_phases, only: :index
        resources :retake_gcse_statuses, only: :index
        resources :situations, only: :index
        resources :teacher_training_adviser_subscription_channels, only: :index
        resources :types, only: :index
        resources :visa_statuses, only: :index
      end
      namespace :contact_creation_channel do
        resources :activities, only: :index
        resources :services, only: :index
        resources :sources, only: :index
      end
      namespace :past_teaching_position do
        resources :education_phases, only: :index
      end
      namespace :phone_call do
        resources :channels, only: :index
      end
      namespace :qualification do
        resources :degree_statuses, only: :index
        resources :types, only: :index
        resources :uk_degree_grades, only: :index
      end
      namespace :service_subscription do
        resources :types, only: :index
      end
      namespace :teaching_event do
        resources :accessibility_items, only: :index
        resources :regions, only: :index
        resources :registration_channels, only: :index
        resources :statuses, only: :index
        resources :types, only: :index
      end
    end
    resources :teaching_event_buildings, only: :index
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
