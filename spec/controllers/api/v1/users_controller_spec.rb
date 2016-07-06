require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  describe 'GET #index' do
    let!(:beautician) do
      create :user, role: :beautician, active: true,
             last_tracked_at: 1.minute.ago, latitude: 1.11, longitude: 2.22
    end
    let(:user) { create :user }
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      get :index, format: :json, access_token: token.token,
          latitude: 1.21, longitude: 2.22
    end

    it { expect(response).to have_http_status(:success) }

    it 'returns languages as JSON' do
      result = json.map { |r| r['id'] }

      expect(result).to eq([beautician.id])
    end
  end

  describe 'GET #show' do
    before do
      get :show, format: :json, id: user.id, access_token: token.token
    end

    context 'show current user' do
      let(:user) { create :user }
      let(:token) { create :access_token, resource_owner_id: user.id }

      it { expect(response).to have_http_status(:success) }

      it 'returns current user as json' do
        result = json['id']

        expect(result).to eq(user.id)
      end
    end

    context 'show other beautician' do
      let(:user) { create :user, role: :beautician }
      let(:other_user) { create :user }
      let(:token) { create :access_token, resource_owner_id: other_user.id }

      it { expect(response).to have_http_status(:success) }

      it 'returns current user as json' do
        result = json['id']

        expect(result).to eq(user.id)
      end
    end

    context 'show other user' do
      let(:user) { create :user }
      let(:other_user) { create :user }
      let(:token) { create :access_token, resource_owner_id: other_user.id }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'with expired access_token' do
      let(:user) { create :user }
      let(:token) do
        create :access_token, resource_owner_id: user.id,
                              expires_in: 0
      end

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to be_empty }
    end
  end
end
