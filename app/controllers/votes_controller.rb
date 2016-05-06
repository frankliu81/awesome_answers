class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    # this won't work, ForbiddenAttributesError
    # @vote = Vote.new(params[:vote])
    # if you have mass attributes, then you will do it
    # with params.require.permit ...
    # here we are being specific, user cannot inject params
    # if you need to share with the view, or other method
    # then you can change it to instance variable
    #vote = Vote.new(is_up: params[:vote][:is_up])
    #vote.question = question
    #vote.user = current_user
    vote = Vote.new(is_up: params[:vote][:is_up],
                    question: question,
                    user: current_user)

    if vote.save
      # better for us to redirect, we want the URL
      # to not be questions/13/votes, but questions/13
      redirect_to question, notice: "Voted!"
    else
      redirect_to question, notice: "Can't vote!"
    end
    #render json: params # print the params
  end

  def update
    # refactor to private method
    #vote = current_user.votes.find params[:id]
    #byebug
    if vote.update(is_up: params[:vote][:is_up])
      redirect_to question, notice: "Vote changed"
    else
      redirect_to question, alert: "Vote wasn't changed"
    end
  end

  def destroy
    # if you don't want to scope with cancancan, you can scope with current_user
    # this needs to be changed later when we have admin though
    # vote = current_user.votes.find params[:id]
    vote.destroy
    redirect_to question, notice: "Vote Undone!"
  end

private

  def question
    @question ||= Question.friendly.find params[:question_id]
  end

  def vote
    @vote = current_user.votes.find params[:id]
  end

end
