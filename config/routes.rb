Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      post '/signup', to: 'users#create'
      post '/login', to: 'users#login'
      get '/user', to: 'users#show'
      put '/user', to: 'users#update'
      resources :users, only: [:update, :show] 
    end
  end
  root 'home#index'
end
