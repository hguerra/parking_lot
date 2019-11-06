module Api
  module V1
    class ParkingCreateSerializer < ActiveModel::Serializer
      attributes :id, :plate
    end
  end
end
