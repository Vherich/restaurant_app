Rails.application.routes.draw do
  resources :menu_items
  resources :orders
  resources :weekly_sales, only: :index do
    collection do
      post :calculate_current_week
    end
  end
  resources :tables
  resources :orders do
    resources :order_items, only: [:destroy]
  end
  get '/login', to: 'sessions#new', as: 'new_session'
  post '/login', to: 'sessions#create', as: 'sessions'
  root 'orders#index'
end
