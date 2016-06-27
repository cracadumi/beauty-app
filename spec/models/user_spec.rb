require 'rails_helper'

describe User, type: :model do
  subject { build(:user) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'not valid without email' do
    subject.email = nil

    expect(subject).not_to be_valid
  end

  it 'not valid without password' do
    subject.password = nil

    expect(subject).not_to be_valid
  end

  it 'default role is user' do
    expect(subject).to be_user
  end

  describe '#display_name' do
    it 'returns the concatenated first and last name if both are present' do
      user = create(:user, name: 'Alex', surname: 'Pushkin', username: '@push')

      result = user.display_name

      expect(result).to eq('Alex Pushkin')
    end

    it 'returns name if name present but surname not' do
      user = build(:user, name: 'Alex', surname: '', username: '@push')

      result = user.display_name

      expect(result).to eq('Alex')
    end

    it 'returns surname if surname present but name not' do
      user = build(:user, name: '', surname: 'Pushkin', username: '@push')

      result = user.display_name

      expect(result).to eq('Pushkin')
    end

    it 'returns email if both name and surname not specified' do
      user = build(:user, email: 'em@il.ru', name: '', surname: '',
                   username: '@push')

      result = user.display_name

      expect(result).to eq('@push')
    end
  end

  describe '#full_name' do
    it 'returns the concatenated first and last name if both are present' do
      user = create(:user, name: 'Alex', surname: 'Pushkin')

      result = user.full_name

      expect(result).to eq('Alex Pushkin')
    end

    it 'returns name if name present but surname not' do
      user = build(:user, name: 'Alex', surname: '')

      result = user.full_name

      expect(result).to eq('Alex')
    end

    it 'returns surname if surname present but name not' do
      user = build(:user, name: '', surname: 'Pushkin')

      result = user.full_name

      expect(result).to eq('Pushkin')
    end

    it 'returns empty string if both name and surname not specified' do
      user = build(:user, email: 'em@il.ru', name: '', surname: '')

      result = user.full_name

      expect(result).to eq('')
    end
  end

  describe '#add_dog_to_username' do
    context 'username without @' do
      subject { build(:user, username: 'gnom') }

      it 'is valid' do
        expect(subject).to be_valid
      end

      it 'adds @ to username before validate' do
        subject.valid?

        result = subject.username

        expect(result).to eq('@gnom')
      end
    end

    context 'username with @' do
      subject { build(:user, username: '@gnom') }

      it 'is valid' do
        expect(subject).to be_valid
      end

      it 'save @ in username' do
        subject.valid?

        result = subject.username

        expect(result).to eq('@gnom')
      end
    end
  end

  describe '#verify' do
    context 'archived user' do
      let(:user) { create(:user, active: false, archived: true) }

      it 'returns error' do
        user.verify
        user.reload

        expect(user.errors).to be_present
      end

      it 'doesn\'t verify user' do
        user.verify
        user.reload

        expect(user).not_to be_active
      end
    end
  end

  describe '#create_settings_beautician' do
    context 'after beautician created' do
      let(:address) { build :address }
      subject { create :user, role: :beautician, address: address }

      it 'creates settings_beautician' do
        result = subject.settings_beautician

        expect(result).to be_persisted
      end

      it 'creates office address equal to user\'s address' do
        result = subject.settings_beautician.office_address.display_name

        expect(result).to eq(subject.address.display_name)
      end

      it 'creates availabilities' do
        result = subject.settings_beautician.availabilities.size

        expect(result).to eq(7)
      end
    end

    context 'after user created' do
      it 'doesn\'t create settings_beautician' do
        result = subject.settings_beautician

        expect(result).to be_nil
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :inet
#  last_sign_in_ip          :inet
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  name                     :string
#  surname                  :string
#  username                 :string
#  role                     :integer          default(0), not null
#  sex                      :integer          default(3), not null
#  bio                      :text
#  phone_number             :string
#  dob_on                   :date
#  profile_picture_url      :string
#  active                   :boolean          default(FALSE), not null
#  archived                 :boolean          default(FALSE), not null
#  latitude                 :float
#  longitude                :float
#  rating                   :integer          default(0), not null
#  facebook_id              :string
#  language_id              :integer
#  location_last_updated_at :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
