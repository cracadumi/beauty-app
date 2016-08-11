require 'rails_helper'

describe Api::V1::BookingsController, type: :controller do
  let(:beautician) { create :user, active: true, role: :beautician }
  let(:user) { create :user, active: true }
  let(:service) { create :service, price: 150.50 }
  let!(:booking) do
    create :booking, user: user, beautician: beautician, services: [service],
           instant: true
  end

  describe 'GET #index' do
    before do
      get :index, format: :json, access_token: token.token
    end

    context 'as user' do
      let(:token) { create :access_token, resource_owner_id: user.id }

      it { expect(response).to have_http_status(:success) }

      it 'returns bookings as JSON' do
        result = json.map { |r| r['id'] }

        expect(result).to eq([booking.id])
      end
    end

    context 'as beautician' do
      let(:token) { create :access_token, resource_owner_id: beautician.id }

      it { expect(response).to have_http_status(:success) }

      it 'returns bookings as JSON' do
        result = json.map { |r| r['id'] }

        expect(result).to eq([booking.id])
      end
    end
  end

  describe 'GET #show' do
    before do
      get :show, format: :json, id: booking.id, access_token: token.token
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
    let(:other_beautician) { create :user, active: true, role: :beautician }
    let(:booking_params) do
      { beautician_id: other_beautician.id, service_ids: [service.id],
        notes: 'new' }
    end
    let(:token) { create :access_token, resource_owner_id: user.id }

    before do
      post :create, format: :json, access_token: token.token,
           booking: booking_params
    end

    it { expect(response).to have_http_status(:success) }

    it 'creates booking' do
      booking = user.bookings.last

      result = booking.notes

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

  describe 'GET #last_unreviewed' do
    let(:other_beautician) { create :user, active: true, role: :beautician }
    let(:other_booking) do
      create :booking, user: user, beautician_id: other_beautician.id,
             service_ids: [service.id]
    end
    let!(:review) do
      create :review, user: user, author: other_beautician,
             booking: other_booking, rating: 5
    end

    before do
      get :last_unreviewed, format: :json, access_token: token.token
    end

    context 'as user' do
      let(:token) { create :access_token, resource_owner_id: user.id }

      it { expect(response).to have_http_status(:success) }

      it 'return booking without review' do
        result = json['id']

        expect(result).to eq(booking.id)
      end
    end

    context 'as beautician' do
      let(:token) { create :access_token, resource_owner_id: beautician.id }

      it { expect(response).to have_http_status(:success) }

      it 'return booking without review' do
        result = json['id']

        expect(result).to eq(booking.id)
      end
    end
  end

  describe 'PUT #cancel' do
    before do
      put :cancel, id: booking.id, format: :json, access_token: token.token
    end

    context 'as user' do
      let(:token) { create :access_token, resource_owner_id: user.id }

      it { expect(response).to have_http_status(:success) }

      it 'cancel booking' do
        booking.reload

        expect(booking).to be_canceled
      end
    end

    context 'as beautician' do
      let(:token) { create :access_token, resource_owner_id: beautician.id }

      it { expect(response).to have_http_status(:success) }

      it 'cancel booking' do
        booking.reload

        expect(booking).to be_canceled
      end
    end
  end

  describe 'PUT #accept' do
    before do
      put :accept, id: booking.id, format: :json, access_token: token.token
    end

    context 'as beautician' do
      let(:token) { create :access_token, resource_owner_id: beautician.id }

      it { expect(response).to have_http_status(:success) }

      it 'accept booking' do
        booking.reload

        expect(booking).to be_accepted
      end
    end
  end

  describe 'PUT #refuse' do
    before do
      put :refuse, id: booking.id, format: :json, access_token: token.token
    end

    context 'as beautician' do
      let(:token) { create :access_token, resource_owner_id: beautician.id }

      it { expect(response).to have_http_status(:success) }

      it 'refuse booking' do
        booking.reload

        expect(booking).to be_refused
      end
    end
  end

  describe 'PUT #check_in' do
    let!(:booking) do
      create :booking, user: user, beautician: beautician, services: [service],
             instant: true, status: :accepted, datetime_at: 1.hour.from_now
    end

    before do
      put :check_in, id: booking.id, format: :json, access_token: token.token
    end

    context 'as beautician' do
      let(:token) { create :access_token, resource_owner_id: beautician.id }

      it { expect(response).to have_http_status(:success) }

      it 'check_in booking' do
        booking.reload

        expect(booking).to be_checked_in
      end
    end
  end

  describe 'PUT #reschedule' do
    before do
      put :reschedule, id: booking.id, format: :json, access_token: token.token,
          booking: { reschedule_at: 1.hour.from_now }
    end

    context 'as beautician' do
      let(:token) { create :access_token, resource_owner_id: beautician.id }

      it { expect(response).to have_http_status(:success) }

      it 'reschedule booking' do
        booking.reload

        expect(booking).to be_rescheduled
      end
    end
  end
end
