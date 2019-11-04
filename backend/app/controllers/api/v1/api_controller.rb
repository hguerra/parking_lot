module Api
  module V1
    class ApiController < ApplicationController
      include ::ActionController::Serialization
    end
  end
end
