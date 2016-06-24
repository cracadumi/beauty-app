class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      can :read, User
      can :destroy, User, id: user.id

      can :read, SettingsBeautician
      can :me, SettingsBeautician
      can :update, SettingsBeautician, user_id: user.id

      can :read, Address
      can :update, Address do |address|
        address.addressable == user ||
          address.addressable.try(:user_id) == user.id
      end

      can :read, Availability
    end
  end
end
