Rails.application.routes.draw do
  get 'navigate/start'
  get 'navigate/controlPanel'
  get 'navigate/clearBase'
  get 'navigate/showUsers'
  resources :orders
  resources :clients
  resources :addresses
  resources :cities
  resources :states
  resources :countries
  resources :imports
  resources :loads


  devise_for :workers
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'navigate#start'
  get 'disp/start'
  get 'integrations/csvImport'
  get 'orders/selectLoad/:id' => 'orders#selectLoad', as: :selectLoad
  get 'orders/removeFromLoad/:id' => 'orders#removeFromLoad', as: :removeFromLoad
  get 'orders/:id/fixSelectedLoad/:load_id' => 'orders#fixSelectedLoad'
  
  get 'orders/:id/updateOriginInfo/:o_id' => 'orders#updateOriginInfo'
  get 'orders/:id/updateOriginInfo' => 'orders#updateOriginInfo'
  get 'orders/autoDistribute/:id' => 'orders#autoDistribute', as: :autoOrderDistribute
  get 'loads/showLoadContent/:id' => 'loads#showLoadContent', as: :showLoadContent
  get 'orders/:id/up' => 'orders#up', as: :orderUp
  get 'orders/:id/down' => 'orders#down', as: :orderDown

  post 'search' => 'search#findPurchase'
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
