require 'rails_helper'

describe Api::V1::ReviewsController, type: :controller do
  let(:beautician) { create :user, active: true, role: :beautician }
  let(:user) { create :user, active: true }
  let(:service) { create :service, price: 150.50 }
  let(:booking) do
    create :booking, user: user, beautician: beautician, services: [service]
  end
  let!(:review) do
    create :review, user: beautician, author: user, booking: booking,
           rating: 5
  end

  describe 'GET #index' do
    before do
      get :index, format: :json, access_token: token.token
    end

    context 'as user' do
      let(:token) { create :access_token, resource_owner_id: user.id }

      it { expect(response).to have_http_status(:success) }

      it 'returns reviews as JSON' do
        result = json.map { |r| r['id'] }

        expect(result).to eq([review.id])
      end
    end

    context 'as beautician' do
      let(:token) { create :access_token, resource_owner_id: beautician.id }

      it { expect(response).to have_http_status(:success) }

      it 'returns reviews as JSON' do
        result = json.map { |r| r['id'] }

        expect(result).to eq([review.id])
      end
    end
  end

  describe 'GET #show' do
    before do
      get :show, format: :json, id: review.id, access_token: token.token
    end

    context 'as user' do
      let(:token) { create :access_token, resource_owner_id: user.id }

      it { expect(response).to have_http_status(:success) }
    end

    context 'as beautician' do
      let(:token) { create :access_token, resource_owner_id: beautician.id }

      it { expect(response).to have_http_status(:success) }
    end

    context 'with expired access_token' do
      let(:token) do
        create :access_token, resource_owner_id: user.id, expires_in: 0
      end

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to be_empty }
    end
  end

  describe 'POST #create' do
    let(:review_params) do
      { rating: 3, comment: 'new' }
    end
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      post :create, format: :json, access_token: token.token,
           booking_id: booking.id, review: review_params
    end

    it { expect(response).to have_http_status(:success) }

    it 'creates review' do
      review = booking.reviews.last

      result = review.comment

      expect(result).to eq('new')
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
