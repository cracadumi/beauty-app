require 'rails_helper'

describe Api::V1::ServicesController, type: :controller do
  describe 'GET #index' do
    let(:beautician) { create :user, active: true, role: :beautician }
    let(:user) { create :user, active: true }
    let(:category) { create :category }
    let!(:service) { create :service, user: beautician, category: category }
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      get :index, format: :json, access_token: token.token
    end

    it { expect(response).to have_http_status(:success) }

    it 'returns services as JSON' do
      result = json.map { |r| r['id'] }

      expect(result).to eq([service.id])
    end
  end
end
