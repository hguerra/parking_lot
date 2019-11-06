Rails.application.routes.draw do
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  # Index
  root to: 'application#not_found'

  # Api definition
  namespace :api do
    namespace :v1 do
      post 'parking'        => 'parking#create'
      put 'parking/:id/pay' => 'parking#pay'
      put 'parking/:id/out' => 'parking#out'
      get 'parking/:plate'  => 'parking#history'
    end
  end

end
