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
      get :show, format: :json, access_token: token.token, me: true
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

  describe 'PUT #update' do
    let(:beautician) { create :user, role: :beautician }
    let!(:settings_beautician) do
      create :settings_beautician, user: beautician, instant_booking: false
    end
    let(:settings_beautician_params) { { instant_booking: true } }
    let(:token) { create :access_token, resource_owner_id: beautician.id }

    before do
      get :update, format: :json, access_token: token.token,
          settings_beautician: settings_beautician_params, me: true
    end

    it { expect(response).to have_http_status(:success) }

    it 'updates settings_beautician' do
      settings_beautician.reload

      expect(settings_beautician).to be_instant_booking
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
