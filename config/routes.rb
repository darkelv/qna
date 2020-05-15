require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  concern :votable do
    post 'vote_up', on: :member
    post 'vote_down', on: :member
    delete 'destroy_vote', on: :member
  end

  concern :commentable do
    resources :comments, only: [:create, :destroy], shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    post 'delete_file', on: :member
    resources :answers, only: %i[create destroy update], concerns: %i[votable commentable], shallow: true do
      post 'set_best', on: :member
      post 'delete_file', on: :member
    end
    resources :subscriptions, only: %i[create destroy], shallow: true
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
  resources :search, only: :index

  mount ActionCable.server => '/cable'
end
