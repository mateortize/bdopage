Rails.application.routes.draw do
  devise_for :accounts
  mount Commontator::Engine => '/commontator'
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
  
  namespace :accounts do
    resources :posts do
      get 'available_videos', on: :member
      put 'select_video', on: :member
    end
    resources :videos
  end

  # Panda Routes
  scope "", default_format: :json do
    post "/panda/authorize_upload", to: "panda#authorize_upload"
    post "/panda/notifications", to: "panda#notifications"
  end

  resources :posts do
    post 'comment', on: :member
    put 'comment', on: :member
  end
  
  root :to => "posts#index"

  get 'account_root' => 'accounts/posts#index', as: :account_root

  get '/:action(/:id)', :controller => 'posts'
end
