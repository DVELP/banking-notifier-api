# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: ENV.fetch('APPLICATION_HOST')

  namespace :api do
    namespace :twilio, defaults: { format: 'xml' } do
      namespace :voice do
        resources :interactions, only: [:create]
        resources :outbound_calls, only: [:create]
      end
    end
  end
end
