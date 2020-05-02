Rails.application.routes.draw do
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
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
