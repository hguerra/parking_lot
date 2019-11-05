module Api
  module V1
    class ParkingController < ApiController
      def create
        parking = Parking.new(parking_params)
        if parking.save
          render json: parking, status: :created
        else
          render_error(parking.errors.full_messages[0], :unprocessable_entity)
        end
      end

      private

      def parking_params
        params.require(:parking).permit(:plate)
      end
    end
  end
end
