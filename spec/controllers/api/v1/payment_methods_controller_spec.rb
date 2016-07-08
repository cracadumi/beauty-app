require 'rails_helper'

describe Api::V1::PaymentMethodsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create :user, active: true }
    let!(:payment_method) { create :payment_method, user: user }
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      get :index, format: :json, access_token: token.token
    end

    it { expect(response).to have_http_status(:success) }

    it 'returns payment_methods as JSON' do
      result = json.map { |r| r['id'] }

      expect(result).to eq([payment_method.id])
    end
  end

  describe 'POST #create' do
    let(:user) { create :user }
    let(:token) { create :access_token, resource_owner_id: user.id }
    let(:payment_method_params) do
      { payment_type: 'card', last_4_digits: 1112, card_type: 'visa' }
    end

    before do
      post :create, format: :json, access_token: token.token,
           payment_method: payment_method_params
    end

    it { expect(response).to have_http_status(:success) }

    it 'creates payment_method for user' do
      payment_method = user.payment_methods.last

      result = payment_method.last_4_digits

      expect(result).to eq(1112)
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
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:token) { create :access_token, resource_owner_id: user.id }
    let!(:payment_method) do
      create :payment_method, user: user, last_4_digits: '1111'
    end
    let!(:second_payment_method) do
      create :payment_method, user: user, last_4_digits: '2222'
    end

    before do
      delete :destroy, format: :json, access_token: token.token,
             id: second_payment_method.id
    end

    it { expect(response).to have_http_status(:success) }

    it 'destroys payment_method' do
      result = PaymentMethod.all

      expect(result).not_to include(second_payment_method)
    end

    context 'other user cannot destroy payment_method' do
      let(:token) { create :access_token, resource_owner_id: other_user.id }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
