require 'rails_helper'

describe Api::V1::AvailabilitiesController, type: :controller do
  describe 'PUT #update' do
    let(:beautician) do
      create :user, role: :beautician, address: build(:address)
    end
    let(:sunday_availability) do
      beautician.settings_beautician.availabilities
                .find_by(day: Availability.days[:sunday])
    end
    let(:availability_params) { { starts_at: '14:35' } }
    let(:token) { create :access_token, resource_owner_id: beautician.id }

    before do
      get :update, format: :json,
          id: sunday_availability.id,
          access_token: token.token, availability: availability_params
    end

    it { expect(response).to have_http_status(:success) }

    it 'updates availability' do
      sunday_availability.reload

      result = sunday_availability.starts_at_time

      expect(result).to eq('14:35')
    end

    context 'other user' do
      let(:other_user) { create :user, role: :beautician }
      let(:token) do
        create :access_token, resource_owner_id: other_user.id,
                              expires_in: 0
      end

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
