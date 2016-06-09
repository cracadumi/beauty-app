require 'rails_helper'

describe Api::V1::CredentialsController, type: :controller do
  describe 'GET #show' do
    let(:user) { create :user }
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      get :show, format: :json, access_token: token.token
    end

    it { expect(response).to have_http_status(:success) }

    it 'returns current user as json' do
      expect(json['id']).to eq(user.id)
    end

    context 'with expired access_token' do
      let(:token) do
        create :access_token, resource_owner_id: user.id,
                              expires_in: 0
      end

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to be_empty }
    end
  end

  describe 'PUT #update' do
    let(:user) { create :user }
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      put :update, format: :json, access_token: token.token,
                   user: { name: 'UpdatedName' }
    end

    it { expect(response).to have_http_status(:success) }

    it 'updated user\'s data' do
      user.reload
      expect(user['name']).to eq('UpdatedName')
    end

    context 'with expired access_token' do
      let(:token) do
        create :access_token, resource_owner_id: user.id,
                              expires_in: 0
      end

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to be_empty }
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create :user, active: true }
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      delete :destroy, format: :json, access_token: token.token,
                   user: { name: 'UpdatedName' }
    end

    it { expect(response).to have_http_status(:success) }

    it 'archives user' do
      user.reload
      expect(user).to be_archived
    end

    it 'set active to false' do
      user.reload
      expect(user).not_to be_active
    end

    it 'revokes user\'s token' do
      token.reload
      expect(token).to be_revoked
    end

    context 'with expired access_token' do
      let(:token) do
        create :access_token, resource_owner_id: user.id,
                              expires_in: 0
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
