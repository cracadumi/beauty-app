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
      user = create(:user, name: 'Alex', surname: 'Pushkin')

      result = user.display_name

      expect(result).to eq('Alex Pushkin')
    end

    it 'returns name if name present but surname not' do
      user = build(:user, name: 'Alex', surname: '')

      result = user.display_name

      expect(result).to eq('Alex')
    end

    it 'returns surname if surname present but name not' do
      user = build(:user, name: '', surname: 'Pushkin')

      result = user.display_name

      expect(result).to eq('Pushkin')
    end

    it 'returns email if both name and surname not specified' do
      user = build(:user, email: 'em@il.ru', name: '', surname: '')

      result = user.display_name

      expect(result).to eq('em@il.ru')
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
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  surname                :string
#  username               :string
#  role                   :integer          default(0), not null
#  sex                    :integer          default(3), not null
#  bio                    :text
#  phone_number           :string
#  dob_on                 :date
#  profile_picture_url    :string
#  active                 :boolean          default(FALSE), not null
#  archived               :boolean          default(FALSE), not null
#  latitude               :float
#  longitude              :float
#  available              :boolean          default(FALSE), not null
#  rating                 :integer          default(0), not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
