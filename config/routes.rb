Rails.application.routes.draw do
  devise_for :customers, controllers: {
    registrations: 'customers/registrations'
  }
  resources :products, except: [:destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'orders' => 'orders#index', as: :orders
  get 'all_orders' => 'orders#all_orders', as: :all_orders
  post 'checkout_orders/:order_id', to: 'orders#checkout', as: :checkout_orders
  delete 'cancel_orders/:order_id' => 'orders#destroy', as: :cancel_orders
  delete 'remove_product/:product_id' => 'orders#remove', as: :remove_products
  get 'add_orders/:product_id', to: 'orders#add', as: :add_orders
  post 'confirm_order', to: 'orders#confirmation', as: :confirm_product

  # Defines the root path route ("/")
  root 'products#index'
end
