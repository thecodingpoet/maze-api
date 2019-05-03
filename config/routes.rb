Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      post '/signup', to: 'users#create'
      post '/login', to: 'users#login'
      get '/user', to: 'users#show'
      put '/user', to: 'users#update'
      post 'writings/save', to: 'writings#save'
      get 'writings/saved', to: 'writings#saved'
      resources :writings do
        member do
          put '/share', to: 'writings#share'
          patch '/archive', to: 'writings#archive'
        end
        resources :comments, only: [:create] do
          member do
            put '/accept', to: 'comments#accept'
            put '/decline', to: 'comments#decline'
          end
        end
      end
      resources :users, only: [:update, :show] do
        member do
          post 'favorite'
        end
      end
    end
  end
  root 'home#index'
end
