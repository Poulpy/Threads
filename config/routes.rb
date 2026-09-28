# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    post '/auth/', to: 'auth#login'
    resources :equipments, only: %i[index show]
    resources :reservations, only: %i[index show create destroy]
  end
end
