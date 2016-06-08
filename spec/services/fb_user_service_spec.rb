require 'rails_helper'

describe FbUserService do
  let(:params) do
    { 'id' => '807413625968693', 'bio' => 'About me',
      'birthday' => '06/16/1988', 'email' => 'oleg@sulyanov.com',
      'first_name' => 'Oleg', 'gender' => 'male', 'last_name' => 'Sulyanov',
      'link' => 'https://www.facebook.com/app_scoped_user_id/807413625968693/',
      'locale' => 'en_US', 'name' => 'Oleg Sulyanov', 'timezone' => 7,
      'updated_time' => '2016-01-25T14:31:54+0000', 'verified' => true }
  end

  describe '#' do
    # TODO: add tests
  end
end
