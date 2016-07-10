class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      can :read, User do |usr|
        usr.beautician? || usr == user
      end
      can [:destroy, :update], User, id: user.id

      can [:read, :me], SettingsBeautician
      can :update, SettingsBeautician, user_id: user.id

      can :read, Address
      can :update, Address do |address|
        address.addressable == user ||
          address.addressable.try(:user_id) == user.id
      end

      can :read, Availability
      can :update, Availability do |address|
        address.settings_beautician.user_id == user.id
      end

      can :read, Language

      can [:read, :create], Picture
      can :destroy, Picture do |picture|
        picture.picturable == user
      end

      can :crud, Favorite, user_id: user.id

      can :read, Service

      can [:crud, :default, :set_default], PaymentMethod, user_id: user.id

      can :create, Booking do
        user.user?
      end

      can [:read, :last_unreviewed], Booking do |booking|
        booking.user == user || booking.beautician == user
      end
    end
  end
end
