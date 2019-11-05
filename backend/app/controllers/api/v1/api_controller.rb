module Api
  module V1
    class ApiController < ApplicationController
      include ::ActionController::Serialization

      include Concerns::ErrorHandler
    end
  end
end
