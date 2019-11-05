require 'api_constraints.rb'

Rails.application.routes.draw do
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  # Index
  root to: 'application#not_found'

  # Api definition
  scope module: :api, defaults: {format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      post 'parking'           => 'parking#create'
      put 'parking/:id/pay' => 'parking#update'
    end
  end

end
