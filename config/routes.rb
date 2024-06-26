Rails.application.routes.draw do
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
