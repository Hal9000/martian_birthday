Rails.application.routes.draw do

  mount Apidoco::Engine, at: "/documentation"

  namespace :api do
    namespace :v1 do
      resources :martian_date, only: [ :show ]
    end
  end

  resources :pages, path: '', only: [] do
    collection do
      get 'faq'
      get 'resources'
      get 'terms-of-service'
      get 'privacy-policy'
      get 'contact-us'
    end
  end

  resources :martiandate, :path => '/', only: :index do
    collection do
      get ':id', to: 'martiandate#index'
    end
  end
end
