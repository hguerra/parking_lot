require 'rails_helper'

module Api
  module V1
    describe Concerns::ErrorHandler, type: :controller do
      controller(ApiController) do
        def fake_not_found
          raise ActiveRecord::RecordNotFound
        end
      end

      before do
        routes.draw { get 'fake_not_found' => 'api/v1/api#fake_not_found' }
      end

      context 'when record not found triggered' do
        it 'renders error' do
          expect(response.status).to eq 404
          expect(json_response['error']['status']).to eq 404
          expect(json_response['error']['message']).to eq 'Registro não encontrado.'
        end
      end
    end
  end
end
