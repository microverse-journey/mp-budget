Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :groups do
    resources :purchases, only: [:new, :create]
  end
  # Defines the root path route ("/")

  authenticated :user do
    root 'groups#index', as: :authenticated_root
  end

  unauthenticated do
    root "splash_screen#index", as: :unauthenticated_root
  end
end
