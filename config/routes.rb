Rails.application.routes.draw do

  devise_for :users
  root 'pages#home'
  resources :users do
    resources :expenses do
      get :report, on: :collection
    end
    get 'report', on: :member
  end

end
