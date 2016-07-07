require 'rails_helper'

describe Api::V1::FavoritesController, type: :controller do
  describe 'GET #index' do
    let(:beautician) { create :user, active: true, role: :beautician }
    let(:user) { create :user, active: true }
    let!(:favorite) { create :favorite, user: user, beautician: beautician }
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      get :index, format: :json, access_token: token.token
    end

    it { expect(response).to have_http_status(:success) }

    it 'returns favorites as JSON' do
      result = json.map { |r| r['id'] }

      expect(result).to eq([favorite.id])
    end
  end

  describe 'POST #create' do
    let(:beautician) { create :user, role: :beautician }
    let(:user) { create :user, active: true }
    let(:token) { create :access_token, resource_owner_id: user.id }
    let(:favorite_params) { { beautician_id: beautician.id } }

    before do
      post :create, format: :json, access_token: token.token,
           favorite: favorite_params
    end

    it { expect(response).to have_http_status(:success) }

    it 'creates favorite for user' do
      favorite = user.favorites.last

      result = favorite.beautician_id

      expect(result).to eq(beautician.id)
    end

    context 'with expired access_token' do
      let(:token) do
        create :access_token, resource_owner_id: user.id,
                              expires_in: 0
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'DELETE #destroy' do
    let(:beautician) { create :user, role: :beautician }
    let(:user) { create :user, active: true }
    let(:other_user) { create :user }
    let(:token) { create :access_token, resource_owner_id: user.id }
    let!(:favorite) { create :favorite, beautician: beautician, user: user }

    before do
      delete :destroy, format: :json, access_token: token.token,
             id: favorite.id
    end

    it { expect(response).to have_http_status(:success) }

    it 'destroys favorite' do
      result = Favorite.all

      expect(result).not_to include(favorite)
    end

    context 'other user cannot destroy favorite' do
      let(:token) { create :access_token, resource_owner_id: other_user.id }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
