Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  concern :voteable do
    member do
      patch :like
      patch :dislike
      patch :revote
    end
  end

  concern :commentable do
    member do
      patch :add_comment
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index] do

      end
    end
  end

  resources :questions, concerns: %i[voteable commentable] do
    resources :answers, concerns: %i[voteable commentable] do
      member do
        patch :best
      end
    end
  end

  resources :files, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
