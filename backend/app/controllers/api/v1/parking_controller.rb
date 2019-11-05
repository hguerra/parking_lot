module Api
  module V1
    class ParkingController < ApiController
      before_action :set_parking, only: [:update]

      def create
        parking = Parking.new(parking_params)
        if parking.save
          render json: parking, status: :created
        else
          render_error(parking.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def update
        if @parking
          if @parking.update({paid: true})
            head :no_content
          else
            render_error(@parking.errors.full_messages[0], :unprocessable_entity)
          end
        else
          render_error(@parking.errors.full_messages[0], :not_found)
        end
      end

      private

      def set_parking
        @parking = Parking.find(params[:id])
      end

      def parking_params
        params.require(:parking).permit(:plate)
      end
    end
  end
end
