Rails.application.routes.draw do
  resources :sessions, only: [:new] do
    get :auth, on: :collection
    delete :revoke, on: :collection
  end
  root 'welcome#index'
end
