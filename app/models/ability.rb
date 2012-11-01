class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(:role_id => Role.find_by_name(:guest).id)

    if user.role.name == "admin"
      can :manage, :all
    end

    if user.role.name == "user"
      #Project
      can [:index, :show, :new, :create], Project
      can [:edit, :update, :destroy], Project do |project|
        project.user_id == user.id
      end
    end

    if user.role.name == "guest"
      #Project
      can [:index, :show], Project
    end
  end
end
