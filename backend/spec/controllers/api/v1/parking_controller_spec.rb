require 'rails_helper'

describe Api::V1::ParkingController, type: :controller do
  describe "POST #create" do
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
end
