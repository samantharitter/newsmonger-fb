FbNewsmonger::Application.routes.draw do
  root 'stories#index'

  resources :stories
  resources :comments
  resource  :session
  resources :users

  get '/stories/:id/upvote_story', to: 'stories#upvote_story'
  get '/stories/:id/show_comments', to: 'stories#show_comments'

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
end
