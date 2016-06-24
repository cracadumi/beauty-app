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
    let(:user) do
      create :user, password: 'my_password', latitude: '1.22', longitude: '2.33'
    end
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      put :update, format: :json, access_token: token.token,
          user: user_params
    end

    describe 'update profile data' do
      let(:user_params) { { name: 'UpdatedName' } }

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

    describe 'update password' do
      let(:user_params) do
        { password: 'newpass', current_password: 'my_password' }
      end

      it { expect(response).to have_http_status(:success) }

      it 'updated user\'s data' do
        user.reload

        expect(user.valid_password?('newpass')).to be true
      end

      context 'current password incorrect' do
        let(:user_params) do
          { password: 'newpass', current_password: 'wrong_password' }
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end

    describe 'update coordinates' do
      let(:user_params) do
        { latitude: '1.111', longitude: '2.222' }
      end

      it { expect(response).to have_http_status(:success) }

      it 'updated coordinates' do
        user.reload

        expect(user.latitude).to eq(1.111)
        expect(user.longitude).to eq(2.222)
      end

      it 'updated location_last_updated_at' do
        user.reload

        result = Time.zone.now.to_i - user.location_last_updated_at.to_i

        expect(result).to be <= 1
      end

      context 'coordinates weren\'t passed' do
        let(:user_params) do
          { name: 'New name' }
        end

        it { expect(response).to have_http_status(:success) }

        it 'coordinates unchanged' do
          user.reload

          expect(user.latitude).to eq(1.22)
          expect(user.longitude).to eq(2.33)
        end

        it 'location_last_updated_at unchanged' do
          user.reload

          result = user.location_last_updated_at

          expect(result).to be nil
        end
      end
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
