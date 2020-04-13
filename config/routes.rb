Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    post 'delete_file', on: :member
    resources :answers, shallow: true do
      post 'set_best', on: :member
      post 'delete_file', on: :member
    end
  end
end
