require 'rails_helper'

describe Api::V1::ParkingController, type: :controller do
  describe 'POST /parking #create' do
    context 'when is created' do
      before(:each) do
        @parking_attributes = attributes_for(:parking)
        post :create, params: {parking: @parking_attributes}
      end

      it 'renders resource created' do
        expect(response).to have_http_status(:created)

        expect(json_response['id']).to_not be_nil
        expect(json_response['plate']).to eq @parking_attributes[:plate]
        expect(json_response['time']).to be_nil
        expect(json_response['paid']).to be_nil
        expect(json_response['left']).to be_nil
        expect(json_response['entry_at']).to be_nil
        expect(json_response['left_at']).to be_nil
      end
    end

    context 'when is not created' do
      before(:each) do
        @parking_attributes = attributes_for(:parking)
        @parking_attributes[:plate] = "#{@parking_attributes[:plate]}0"
        post :create, params: {parking: @parking_attributes}
      end

      it 'renders errors' do
        expect(response).to have_http_status(:unprocessable_entity)

        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 422
        expect(json_response['error']['message']).to_not be_nil
      end
    end
  end

  describe 'PUT /parking/:id/pay #update' do
    context 'when is updated' do
      before(:each) do
        @parking = create(:parking)
        put :update, params: {id: @parking.id}
      end

      it 'renders resource updated' do
        expect(response).to have_http_status(:no_content)
        expect(response.body).to eq ""
      end

      it 'modify the parking' do
        actual_parking = Parking.find(@parking.id)
        expect(actual_parking.paid).to be true
      end
    end

    context 'when is not updated' do
      before(:each) do
        put :update, params: {id: 0}
      end

      it 'renders errors' do
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 404
        expect(json_response['error']['message']).to eq 'Registro não encontrado.'
      end
    end
  end
end
