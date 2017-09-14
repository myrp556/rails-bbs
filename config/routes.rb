Rails.application.routes.draw do
  get 'ability/initialize'

  mount Ckeditor::Engine => '/ckeditor'
  get '/active/edit/<token>' => 'account_activations#edit'
  root 'home#index'
  get '/cv' => 'cv#index'

  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  #patch '/user/update' => 'users#update'
  get '/users' => 'users#list'
  get '/user/delete' => 'users#destroy'
  get '/user/passwd' => 'users#passwd'
  patch '/user_passwd' => 'users#update_passwd'
  patch '/user_detail' => 'users#update_detail'
  get '/user_detail' => 'users#detail'
  post '/user_icon' => 'users#update_icon'
  get '/user_manage' => 'users#manage'
  get '/get_user_ball' => 'users#get_user_ball'
  post '/set_user_ball' => 'users#set_user_ball'
  get '/search_user_name' => 'users#search_user_name'
  get '/favorites' => 'users#favorites'
  get '/add_user_favorite' => 'users#add_user_favorite'
  get '/delete_user_favorite' => 'users#delete_user_favorite'

  get '/user_manage_zones' => 'users#get_user_manage_zones'
  post '/user_manage_zones' => 'users#post_user_manage_zones'
  get '/zones' => 'zone#get_zones'

  get '/login' => 'sessions#new', as: :login
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy', as: :logout

  get '/passwd_reset' => 'passwd_reset#main'
  post '/passwd_reset' => 'passwd_reset#create'
  get '/password_reset' => 'passwd_reset#receive'
  post '/password_reset' => 'passwd_reset#reset'

  get '/user_info' => 'user#info'

  get '/zone' => 'zone#main'
  get '/topic' => 'topic#main'

  get '/new_zone' => 'zone#new_zone'
  post '/new_zone' => 'zone#create_zone'
  get '/delete_zone' => 'zone#destroy_zone'
  get '/edit_zone' => 'zone#edit_zone'
  patch '/update_zone' => 'zone#update_zone'
  get '/delete_zone' => 'zone#destroy_zone'
  post '/zone_icon' => 'zone#update_icon'
  get '/set_top_topic' => 'zone#set_top_topic'
  get '/cancle_top_topic' => 'zone#cancle_top_topic'

  post '/new_topic' => 'zone#create_topic'
  get '/delete_topic' => 'zone#destroy_topic'
  get '/edit_topic' => 'zone#edit_topic'
  patch '/update_topic' => 'zone#update_topic'
  get '/set_topic_color' => 'zone#set_topic_color'
  get '/set_topic_nice' => 'zone#set_topic_nice'
  get '/cancle_topic_nice' => 'zone#cancle_topic_nice'

  post '/new_reply' => 'topic#create_note'
  get '/delete_reply' => 'topic#destroy_note'
  get '/edit_reply' => 'topic#edit_note'
  patch '/update_reply' => 'topic#update_note'
  post '/reply_to_note' => 'topic#reply_to_note'
  post '/topic_vote' =>  'topic#topic_vote'

  get '/mails' => 'mail#main'
  get '/mail_inbox' => 'mail#in_box'
  get '/mail_outbox' => 'mail#out_box'
  get '/new_mail' => 'mail#new'
  post '/new_mail' => 'mail#create'
  get '/delete_mail' => 'mail#delete'
  get '/get_user_mails' => 'mail#get_user_pmails'
  get '/get_user_mail' => 'mail#get_user_pmail'
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
