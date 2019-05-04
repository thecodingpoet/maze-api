Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      post '/signup', to: 'users#create'
      post '/login', to: 'users#login'
      get '/user', to: 'users#show'
      put '/user', to: 'users#update'
      get '/timeline', to: 'writings#timeline'
      get '/supports', to: 'writings#support'
  
      resources :writings do
        member do
          patch '/archive', to: 'writings#archive'
          put '/drafts', to: 'writings#update_draft'
          patch '/drafts/publish', to: 'writings#publish_draft'
        end
        collection do 
          get '/drafts', to: 'writings#drafts'
          post '/drafts', to: 'writings#save_draft'
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
