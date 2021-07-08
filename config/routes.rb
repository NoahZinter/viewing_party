Rails.application.routes.draw do
  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#create'


  get '/discover', to: 'movies#discover', as: 'discover'
  get '/movies', to: 'movies#movies', as: 'movies'
  get '/movies/:id', to: 'movies#show', as: 'movie'

  get '/dashboard', to: 'dashboard#index', as: 'dashboard'


  get '/register', to: 'users#new'
  resources :users

  root to: 'sessions#welcome'
end
