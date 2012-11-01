class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(:role_id => Role.find_by_name(:guest).id)

    if user.role? :admin
      can :manage, :all
    end

    if user.role? :user
    end

    if user.role? :guest
    end
  end
end
