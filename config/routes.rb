Rails.application.routes.draw do
  devise_for :customers, controllers: {
    registrations: 'customers/registrations'
  }
  resources :products, except: [:destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'orders' => 'orders#index', as: :orders
  get 'all_orders' => 'orders#all_orders', as: :all_orders
  post 'add_orders/:product_id', to: 'orders#add', as: :add_orders
  delete 'remove_product/:product_id' => 'orders#remove', as: :remove_products

  # Defines the root path route ("/")
  root 'products#index'
end
