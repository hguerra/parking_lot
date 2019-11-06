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

      it 'create the parking' do
        actual_parking = Parking.find(json_response['id'])

        expect(actual_parking.paid).to be false
        expect(actual_parking.left).to be false
        expect(actual_parking.entry_at).to_not be_nil
        expect(actual_parking.left_at).to be_nil
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

  describe 'PUT /parking/:id/pay #pay' do
    context 'when pay is valid' do
      before(:each) do
        @parking = create(:parking)
        put :pay, params: {id: @parking.id}
      end

      it 'renders resource updated' do
        expect(response).to have_http_status(:no_content)
        expect(response.body).to eq ""
      end

      it 'modify the parking' do
        actual_parking = Parking.find(@parking.id)
        expect(actual_parking.paid).to be true
        expect(actual_parking.left).to be false
      end
    end

    context 'when pay is not valid' do
      before(:each) do
        put :pay, params: {id: 0}
      end

      it 'renders errors' do
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 404
        expect(json_response['error']['message']).to eq 'Record not found.'
      end
    end
  end

  describe 'PUT /parking/:id/out #out' do
    context 'when out is valid' do
      before(:each) do
        @parking = create(:parking)
        put :pay, params: {id: @parking.id}
        put :out, params: {id: @parking.id}
      end

      it 'renders resource updated' do
        expect(response).to have_http_status(:no_content)
        expect(response.body).to eq ""
      end

      it 'modify the parking' do
        actual_parking = Parking.find(@parking.id)
        expect(actual_parking.paid).to be true
        expect(actual_parking.left).to be true
        expect(actual_parking.left_at).to_not be_nil
      end
    end

    context 'when out is not valid because record does not exist' do
      before(:each) do
        put :out, params: {id: 0}
      end

      it 'renders errors' do
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 404
        expect(json_response['error']['message']).to eq 'Record not found.'
      end
    end

    context 'when out is not valid because the parking was not paid' do
      before(:each) do
        @parking = create(:parking)
        put :out, params: {id: @parking.id}
      end

      it 'renders errors' do
        expect(json_response['error']).to_not be_nil
        expect(json_response['error']['status']).to eq 422
        expect(json_response['error']['message']).to eq 'Parking must be paid.'
      end
    end
  end
end
