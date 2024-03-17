Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :voteable do
    member do
      patch :like
      patch :dislike
    end
  end

  resources :questions, concerns: [:voteable] do
    resources :answers do
      member do
        patch :best
      end
    end
  end

  resources :files, only: :destroy
  resources :rewards, only: :index
end
