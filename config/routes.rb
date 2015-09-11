Rails.application.routes.draw do
  resources :contracts, only: [:index] do
    resources :stations, only: [:index]
  end

  resources :stations, only: [:show]

  root "contracts#index"
end
