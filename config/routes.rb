Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :voteable do
    member do
      patch :like
      patch :dislike
      patch :revote
    end
  end

  resources :questions, concerns: [:voteable] do
    resources :answers, concerns: [:voteable] do
      member do
        patch :best
      end
    end
  end

  resources :files, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
