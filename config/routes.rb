Rails.application.routes.draw do
  devise_for :users
   root 'products#index'
   resources :products do
      resources :carts
   end
   resources :carts
   get '/total_bill', to: 'carts#total_bill'
   post '/place_order', to: 'carts#place_order'
   get '/confirm_order', to: 'carts#confirm_order'


end