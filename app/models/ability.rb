class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :read, :search
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]

    can [:update, :destroy], [Question, Answer, Comment], user: user

    can %i[vote_up vote_down destroy_vote], [Question, Answer] do |item|
      !user.author_of?(item)
    end

    can :create, Subscription

    can :destroy, Subscription do |sub|
      user.author_of?(sub)
    end

    can :set_best, Answer, question: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }
    can :destroy, Link, linkable: { user_id: user.id }
  end
end
