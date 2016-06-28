require 'rails_helper'

describe Api::V1::PicturesController, type: :controller do
  context 'ME/' do
    describe 'GET #index' do
      let(:beautician) { create :user, role: :beautician }
      let(:token) { create :access_token, resource_owner_id: beautician.id }
      let!(:picture) do
        create :picture, title: 'Test 1', picture_url: 'http://pic.jpeg',
               picturable: beautician
      end

      before do
        get :index, format: :json, access_token: token.token
      end

      it { expect(response).to have_http_status(:success) }

      it 'returns pictures as json' do
        result = json.map { |r| r['id'] }

        expect(result).to contain_exactly(picture.id)
      end
    end

    describe 'GET #show' do
      let(:beautician) { create :user, role: :beautician }
      let(:token) { create :access_token, resource_owner_id: beautician.id }
      let!(:picture) do
        create :picture, title: 'Test 1', picture_url: 'http://pic.jpeg',
               picturable: beautician
      end

      before do
        get :show, format: :json, id: picture.id, access_token: token.token
      end

      it { expect(response).to have_http_status(:success) }

      it 'returns picture as json' do
        result = json['id']

        expect(result).to eq(picture.id)
      end
    end

    describe 'POST #create' do
      let(:beautician) { create :user, role: :beautician }
      let(:token) { create :access_token, resource_owner_id: beautician.id }
      let(:picture_params) do
        { title: 'Test 1', picture_url: 'http://pic.jpeg' }
      end

      before do
        post :create, format: :json, access_token: token.token,
             picture: picture_params
      end

      it { expect(response).to have_http_status(:success) }

      it 'creates picture for user' do
        picture = beautician.pictures.last

        result = picture.title

        expect(result).to eq('Test 1')
      end

      context 'with expired access_token' do
        let(:token) do
          create :access_token, resource_owner_id: beautician.id,
                                expires_in: 0
        end

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end

    describe 'DELETE #destroy' do
      let(:beautician) { create :user, role: :beautician }
      let(:other_user) { create :user, role: :beautician }
      let(:token) { create :access_token, resource_owner_id: beautician.id }
      let!(:picture) do
        create :picture, title: 'Test 1', picture_url: 'http://pic.jpeg',
               picturable: beautician
      end

      before do
        delete :destroy, format: :json, access_token: token.token,
               id: picture.id
      end

      it { expect(response).to have_http_status(:success) }

      it 'destroys picture' do
        result = Picture.all

        expect(result).not_to include(picture)
      end

      context 'other user cannot destroy picture' do
        let(:token) { create :access_token, resource_owner_id: other_user.id }

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end
  end
end
