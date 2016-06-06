module Api
  module V1
    class RegistrationsController < Api::V1::V1Controller
      resource_description do
        short 'User Registration'
      end

      api! 'Register user'
      description <<-EOS
        ## Description
        Users registration
      EOS
      param :user, Hash, desc: 'User info', required: true do
        param :email, String, desc: 'Email', required: true
        param :password, String, desc: 'Password', required: true
        param :name, String, desc: 'Name', required: true
        param :surname, String, desc: 'Surname', required: true
        param :username, String, desc: 'Username. Starts with @, without spaces'
        param :role, %w(beautician user), desc: 'Sex. Other by default.'
        param :sex, %w(male female other), desc: 'Role. User by default.'
      end

      def create
        @user = User.new(user_params)
        # user can't register as admin via API
        @user.role = :user if @user.admin?
        @user.active = true unless @user.beautician?
        @user.save
        respond_with @user
      end

      private

      def user_params
        params.require(:user).permit(:role, :email, :password, :name, :surname,
                                     :username, :sex)
      end
    end
  end
end
