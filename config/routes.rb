Rails.application.routes.draw do
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

  namespace :wallets do
    get :new_import
    post :import

    get :new_generate
    post :generate
  end

  namespace :exchange_rates do
    get :fetch
  end

  namespace :transactions do
    post :post
  end
end
