class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_create, only: :create
  before_action :authorize_destroy, only: :destroy

  def create
    # question refactored below
    # question = Question.find params[:question_id]
    like = Like.new
    like.user = current_user
    like.question = question
    if like.save
      #redirect_to question_path(@question)
      # question is a short form for question_path(@quesiton)
      redirect_to question, notice: "Liked!"
    else
      redirect_to question, alert: "You've Already Liked!"
  end

  end

  def destroy
    # permission on the question, permission on the like
    # that's why people do the separate look up
    #question = Question.find params[:question_id]
    # sometime may want to ensure like is within question
    #like = question.likes.find params[:id]
    # like refactored
    #like = Like.find params[:id]

    like.destroy
    #redirect_to question, notice: "Un-liked!"
    # greg' suggested to use like.question_id directly
    redirect_to question_path(like.question_id), notice: "Un-liked!"
  end

  private

  def authorize_create
    # question is now the question method
    redirect_to question, notice: "Can't Like!" unless can? :like, question
  end

  def authorize_destroy
    redirect_to question, notice: "Can't Un-like!" unless can? :destroy, like
  end

  def question
    @question ||= Question.find params[:question_id]
  end

  def like
    @like ||= Like.find params[:id]
  end

end
