module Constraints
  class Subdomain
    def self.matches?(request)
      request.subdomain.present? && request.subdomain != 'www'
    end
  end

  class NoSubdomain
    def self.matches?(request)
      request.subdomain == 'www' || !request.subdomain.present?
    end
  end
end

Rails.application.routes.default_url_options[:host] = Rails.application.config.domain

Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    # If there's a user, root is home index
    authenticated :user do
      root 'backends#index', as: :authenticated_root
      resources :backends do
        # This isn't a has many but they are created in the schema belonging to the backend so
        # nest regardless
        namespace :multitenanted do
          resources :tables do
            resources :records
          end
          resources :users
        end
      end

      resources :settings, only: :index

      namespace :billing do
        resources :plans, only: :index
      end
    end

    # If there's no user, root is log in page
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  constraints Constraints::Subdomain do
    namespace :api do
      namespace :v1 do

        devise_for :users,
                   class_name: 'Multitenanted::User',
                   controllers: { sessions: 'api/v1/sessions',
                                  registrations: 'api/v1/registrations' }
        # Index  GET test.lvh.me:3000/asds
        # Show  GET test.lvh.me:3000/asds/1
        # Create  POST test.lvh.me:3000/asds
        # Update  PUT test.lvh.me:3000/asds/1
        # Destroy DELETE test.lvh.me:3000/asds/1

        # Manualy write these because they're not REST with the model names
        get '/:table_name'        => 'records#index'
        get '/:table_name/:id'    => 'records#show'
        post '/:table_name'       => 'records#create'
        patch '/:table_name/:id'  => 'records#update'
        put '/:table_name/:id'    => 'records#update'
        delete '/:table_name/:id' => 'records#destroy'

      end
    end
  end
end
