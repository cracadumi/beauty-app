require 'rails_helper'

describe Api::V1::LanguagesController, type: :controller do
  describe 'GET #index' do
    let!(:language) { create :language, name: 'Russian', country: 'RU' }
    let(:user) { create :user, active: true }
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      get :index, format: :json, access_token: token.token
    end

    it { expect(response).to have_http_status(:success) }

    it 'returns languages as JSON' do
      result = json.map { |r| r['id'] }

      expect(result).to eq([language.id])
    end
  end
end
