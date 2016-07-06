require 'rails_helper'

describe Api::V1::FavoritesController, type: :controller do
  describe 'GET #index' do
    let(:beautician) { create :user, active: true, role: :beautician }
    let(:user) { create :user, active: true }
    let!(:favorite) { create :favorite, user: user, beautician: beautician }
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      get :index, format: :json, access_token: token.token, me: true
    end

    it { expect(response).to have_http_status(:success) }

    it 'returns favorites as JSON' do
      result = json.map { |r| r['id'] }

      expect(result).to eq([favorite.id])
    end
  end
end
