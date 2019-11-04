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
    end
  end

end
