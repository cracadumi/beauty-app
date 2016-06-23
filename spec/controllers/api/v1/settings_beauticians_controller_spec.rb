require 'rails_helper'

describe Api::V1::SettingsBeauticiansController, type: :controller do
  describe 'GET #show' do
    let(:beautician) { create :user, role: :beautician }
    let(:other_user) { create :user }
    let(:token) { create :access_token, resource_owner_id: other_user.id }

    before do
      get :show, format: :json, id: beautician.id, access_token: token.token
    end

    xit { expect(response).to have_http_status(:success) }

    context 'with expired access_token' do
      let(:token) do
        create :access_token, resource_owner_id: other_user.id,
                              expires_in: 0
      end

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to be_empty }
    end
  end

  describe 'GET #me' do
    let(:beautician) { create :user, role: :beautician }
    let!(:settings_beautician) { create :settings_beautician, user: beautician }
    let(:token) { create :access_token, resource_owner_id: beautician.id }

    before do
      get :show, format: :json, access_token: token.token
    end

    it { expect(response).to have_http_status(:success) }

    context 'with expired access_token' do
      let(:token) do
        create :access_token, resource_owner_id: beautician.id,
                              expires_in: 0
      end

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to be_empty }
    end
  end
end
