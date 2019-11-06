module Api
  module V1
    class ParkingController < ApiController
      include ActionView::Helpers::DateHelper
      before_action :set_parking_by_id, only: [:pay, :out]

      def create
        parking = Parking.new(parking_params)
        if parking.save
          render json: parking, status: :created, serializer: Api::V1::ParkingCreateSerializer
        else
          render_error(parking.errors.full_messages[0], :unprocessable_entity)
        end
      end

      def pay
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

      def out
        if @parking
          if @parking.paid
            left_at = Time.now
            time = distance_of_time_in_words(@parking.entry_at, left_at)

            if @parking.update({left: true, left_at: left_at, time: time})
              head :no_content
            else
              render_error(@parking.errors.full_messages[0], :unprocessable_entity)
            end
          else
            render_error('Parking must be paid.', :unprocessable_entity)
          end
        else
          render_error(@parking.errors.full_messages[0], :not_found)
        end
      end

      def history
        parking = Parking.where(plate: params[:plate]).order(:id)
        parking.each do |p|
          p.time = distance_of_time_in_words(p.entry_at, Time.now) unless p.time
        end

        render json: parking, status: :ok, each_serializer: Api::V1::ParkingHistorySerializer
      end

      private

      def set_parking_by_id
        @parking = Parking.find(params[:id])
      end

      def parking_params
        params.require(:parking).permit(:plate)
      end
    end
  end
end
