module Api
  module V1
    class ParkingSerializer < ActiveModel::Serializer
      attributes :id, :plate
    end
  end
end
