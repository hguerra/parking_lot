module Api
  module V1
    class ParkingHistorySerializer < ActiveModel::Serializer
      attributes :id, :time, :paid, :left
    end
  end
end
