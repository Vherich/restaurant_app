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

  root 'orders#index'
end
