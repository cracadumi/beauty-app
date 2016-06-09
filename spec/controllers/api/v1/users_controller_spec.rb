require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  describe 'GET #show' do
    let(:user) { create :user }
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      get :show, format: :json, id: user.id, access_token: token.token
    end

    it { expect(response).to have_http_status(:success) }

    it 'returns current user as json' do
      result = json['id']

      expect(result).to eq(user.id)
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
end
