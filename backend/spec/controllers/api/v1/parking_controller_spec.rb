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

    context 'when params not valid' do
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
        expect(actual_parking.time).to_not be_nil
        expect(actual_parking.time).to eq 'less than a minute'
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

  describe 'GET /parking/:plate #history' do
    context 'when there are no records' do
      before(:each) do
        get :history, params: {plate: 'AAA-9999'}
      end

      it 'renders resource history' do
        expect(response).to have_http_status(:ok)
        expect(json_response).to_not be_nil
        expect(json_response.length).to eq 0
      end
    end

    context 'when there is only one record and not left' do
      before(:each) do
        @parking = create(:parking)
        get :history, params: {plate: @parking.plate}
      end

      it 'renders resource history' do
        expect(response).to have_http_status(:ok)
        expect(json_response).to_not be_nil
        expect(json_response.length).to eq 1
      end

      it 'vehicle not left' do
        actual_parking = Parking.find(@parking.id)
        expect(json_response[0]['id']).to eq actual_parking.id
        expect(json_response[0]['plate']).to be_nil
        expect(actual_parking.time).to be_nil
        expect(json_response[0]['time']).to_not be_nil
        expect(json_response[0]['paid']).to be false
        expect(json_response[0]['left']).to be false
        expect(json_response[0]['entry_at']).to be_nil
        expect(json_response[0]['left_at']).to be_nil
      end
    end

    context 'when there is only one record and left' do
      before(:each) do
        @parking = create(:parking)
        put :pay, params: {id: @parking.id}
        put :out, params: {id: @parking.id}
        get :history, params: {plate: @parking.plate}
      end

      it 'renders resource history' do
        expect(response).to have_http_status(:ok)
        expect(json_response).to_not be_nil
        expect(json_response.length).to eq 1
      end

      it 'vehicle left' do
        actual_parking = Parking.find(@parking.id)
        expect(json_response[0]['id']).to eq actual_parking.id
        expect(json_response[0]['plate']).to be_nil
        expect(json_response[0]['time']).to eq actual_parking.time
        expect(json_response[0]['paid']).to be true
        expect(json_response[0]['left']).to be true
        expect(json_response[0]['entry_at']).to be_nil
        expect(json_response[0]['left_at']).to be_nil
      end
    end

    context 'when there are many records' do
      before(:each) do
        @parking_one = create(:parking)
        put :pay, params: {id: @parking_one.id}
        put :out, params: {id: @parking_one.id}

        post :create, params: {parking: {plate: @parking_one.plate}}
        get :history, params: {plate: @parking_one.plate}
      end

      it 'renders resource history' do
        expect(response).to have_http_status(:ok)
        expect(json_response).to_not be_nil
        expect(json_response.length).to eq 2
      end

      it 'compare plates' do
        expect(json_response[0]['id']).to_not be_nil
        expect(json_response[1]['id']).to_not be_nil
        expect(json_response[0]['left']).to be true
        expect(json_response[1]['left']).to be false
      end
    end
  end
end
