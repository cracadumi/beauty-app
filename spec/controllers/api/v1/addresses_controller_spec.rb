require 'rails_helper'

describe Api::V1::AddressesController, type: :controller do
  describe 'PUT #update' do
    let(:beautician) do
      create :user, role: :beautician, address: build(:address)
    end
    let(:address_params) { { street: 'Arbat' } }
    let(:token) { create :access_token, resource_owner_id: beautician.id }

    before do
      get :update, format: :json,
          id: beautician.settings_beautician.office_address.id,
          access_token: token.token, address: address_params
    end

    it { expect(response).to have_http_status(:success) }

    it 'updates address' do
      beautician.settings_beautician.office_address.reload

      result = beautician.settings_beautician.office_address.street

      expect(result).to eq('Arbat')
    end

    context 'other user' do
      let(:other_user) { create :user, role: :beautician }
      let(:token) do
        create :access_token, resource_owner_id: other_user.id,
                              expires_in: 0
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
