Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  devise_for :accounts, :controllers => {:registrations => "registrations", :sessions => "sessions"}
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
  
  get '/auth/:provider/callback', to: 'omniauth#create'
  post '/auth/:provider/callback', to: 'omniauth#create'
  get '/auth/failure', to: redirect('/')

  # Panda Routes
  scope "", default_format: :json do
    post "/panda/authorize_upload", to: "panda#authorize_upload"
    post "/panda/notifications", to: "panda#notifications"
  end

  namespace :admin do
    resources :posts do
      put :publish, on: :member
      put :unpublish, on: :member
      put :restore, on: :member
      delete :really_destroy, on: :member 

      resource :video do
        get :refresh, on: :collection
      end
    end

    namespace :pages do
      resource :imprint
    end
    
    resource :profile
    resource :setting
    resources :orders, only: [:index, :new, :create]

    get '/' => 'posts#index'
  end

  get '' => 'posts#index', as: :account_root
  
  resources :accounts do
    put :follow, on: :member
    put :unfollow, on: :member
    get :videos, on: :member
    get :imprint, on: :member
  end

  resources :posts
  resource :profile

  resources :pages, only:[] do
    collection do
      get :imprint
      get :terms_and_conditions
      get :contact
      get :promotion
    end
  end

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  root :to => "posts#index"
end
