Rails.application.routes.draw do
  resources :exchange_rates do
    get 'fetch_exchange_rates', on: :collection
  end

  root 'exchange_rates#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
