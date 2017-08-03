Rails.application.routes.draw do
  root 'home#index'

  get '/user/detail' => 'users#detail'
  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  get '/user/edit' => 'users#edit'
  #patch '/user/update' => 'users#update'
  get '/user/delete' => 'users#destroy'
  get '/user/passwd' => 'users#passwd'
  patch '/user/passwd' => 'user#update_passwd'
  patch '/user/mail' => 'user#update_mail'

  get '/login' => 'sessions#new', as: :login
  post '/login' => 'sessions#create'
  get '/logout' => 'session#destroy', as: :logout

  get '/zone' => 'zone#main'
  get '/topic' => 'topic#main'

  post '/new_topic' => 'zone#create_topic'
  delete '/delete_topic' => 'zone#destroy_topic'
  get '/edit_topic' => 'zone#edit_topic'
  patch '/update_topic' => 'zone#update_topic'

  post '/new_reply' => 'topic#create_note'
  delete '/delete_reply' => 'topic#destroy_note'
  get '/edit_reply' => 'topic#edit_note'
  patch '/update_reply' => 'topic#update_note'

  #resources :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
