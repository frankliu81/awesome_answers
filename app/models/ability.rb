class Ability
  include CanCan::Ability


  # that you have a method in your ApplicationController called 'current_user'
  # you don't need to automatically create an ability object
  # we just need to learn how to write authorization rule and how to use them

  def initialize(user)
    # we instantiate the user to User.new to avoid having user be nil if the user
    # is not signed in.  We assume here that 'user' wil be 'User.new' if
    # the user is not signed in.
    user ||= User.new
    # this gives superpowers
    #puts "=============== user.admin"
    #puts user.admin?
    can :manage, :all if user.admin?

    alias_action :create, :read, :edit, :udpate, :destroy, :to => :crud
    # defining the ability to :manage (do anything) with a question
    # in the case below we put inside the block an expression that will return
    # true or false.  This will determine whether the user is allowed to manage
    # a question or not
    # can :destroy
    # can :manage is a catch out
    can :crud, Question do |q|
      # making sure user is persisted in the database
      q.user == user && user.persisted?
    end

    can :crud, Answer do |ans|
      (ans.question.user == user || ans.user == user) && user.persisted?
    end

    can :like, Question do |q|
      # prevent user from liking their own question
      q.user != user
    end

    can :destroy, Like do |l|
      # deleting likes that are not yours
      # the way we wrote the code, we just use the like id to
      # destroy, instead of current_user.find, if we use admin
      # it is harder to maintain the code
      # if like, and inspect elemnt, questions/16/like/27, and switch to
      # 27, and try to delete someone else's like
      l.user == user
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
