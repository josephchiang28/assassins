Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => 'omniauth_callbacks' }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'pages#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  get 'dashboard' => 'users#dashboard', as: :user_dashboard
  post 'games/create_or_join' => 'games#create_or_join', as: :create_or_join_game
  get 'games/:name' => 'games#show', as: :show_game
  post 'games/:name/join_team' => 'games#join_team', as: :join_team
  post 'games/:name/generate_assignments' => 'games#generate_assignments', as: :generate_assignments
  get 'games/:name/assignments' => 'games#assignments', as: :assignments
  get 'games/:name' => 'games#activate_game', as: :activate_game
  post 'teams/create' => 'teams#create', as: :create_team
  post 'teams/delete' => 'teams#delete', as: :delete_team

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
