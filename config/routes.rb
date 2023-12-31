Rails.application.routes.draw do
  devise_for :customers, controllers: {
    registrations: 'customers/registrations'
  }
  resources :products, except: [:destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'all_orders' => 'orders#all_orders', as: :all_orders

  # Defines the root path route ("/")
  root 'products#index'
end
