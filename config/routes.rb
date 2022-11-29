Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'users#new'

  resources :users, only: %i[create] do
    collection do
      get :me
    end
  end

  namespace :auth do
    get :sign_up, to: '/users#new'
    get :sign_in, to: '/sessions#new'
    delete :sign_out, to: '/sessions#destroy'
    post :create, to: '/sessions#create', as: :create_session
  end
end
