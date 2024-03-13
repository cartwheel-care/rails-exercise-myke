Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/", to: "home#index"

  resources :patients do
    member do
      put :sync
    end
  end

  resources :contacts

  # Defines the root path route ("/")
  root "home#index"
end
