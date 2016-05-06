class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_create, only: :create
  before_action :authorize_destroy, only: :destroy
  before_action :question # this will call the question method to force
                          # finding a question as we will need it for both
                          # the create and destroy actions when we render
                          # the _like.html.erb partial and the user_like
                          # in questions_helper.rb tries to access @question

  def create
    # question refactored below
    # question = Question.friendly.find params[:question_id]
    like = Like.new
    like.user = current_user
    like.question = question

    respond_to do |format|
      if like.save
        #redirect_to question_path(@question)
        # question is a short form for question_path(@quesiton)
        format.html { redirect_to question, notice: "Liked!" }
        format.js { render } # likes/create.js.erb
      else
        format.html { redirect_to question, alert: "You've Already Liked!"}
        # user click too quickly
        format.js { render js: "alert('Can\'t like, please refresh the page!');" }
      end
    end

  end

  def destroy
    # permission on the question, permission on the like
    # that's why people do the separate look up
    #question = Question.friendly.find params[:question_id]
    # sometime may want to ensure like is within question
    #like = question.likes.find params[:id]
    # like refactored
    #like = Like.find params[:id]

    like.destroy
    respond_to do |format|
      #redirect_to question, notice: "Un-liked!"
      # greg' suggested to use like.question_id directly
      format.html { redirect_to question_path(like.question_id), notice: "Un-liked!"}
      format.js { render }
    end
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
    @question ||= Question.friendly.find params[:question_id]
  end

  def like
    @like ||= Like.find params[:id]
  end

end
