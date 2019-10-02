# frozen_string_literal: true

Rails.application.routes.draw do

  namespace :twilio do
    namespace :voice do
      resources :interactions, only: [:create]
      resources :incomings, only: [:create]
    end
  end
end
