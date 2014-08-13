Rails.application.routes.draw do
  #root to: 'visitors#index'
  #devise_for :users
  #resources :users


  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  resources :home, only: [:index]
  root :to => "home#index"
  devise_for :users

  namespace :api, defaults: {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do

      devise_scope :user do
        match '/sessions' => 'sessions#create', :via => :post
        match '/sessions' => 'sessions#destroy', :via => :delete
      end

      #resources :record

      #resources :users, only: [:create]
      #match '/users' => 'users#show', :via => :get
      #match '/users' => 'users#update', :via => :put
      #match '/users' => 'users#destroy', :via => :delete
    end
  end



end
