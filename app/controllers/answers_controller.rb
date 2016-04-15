class AnswersController < ApplicationController

  before_action :authenticate_user!

  def create
      # you want to make sure the question exists first before you
      # create an answer with that question
      # find would throw an exception, and show a 4040 page
      @question = Question.find params[:question_id]

      # ForbiddenAttributesError
      #answer = Answer.new params[:answer]
      answer_params = params.require(:answer).permit(:body)
      @answer = Answer.new answer_params
      # this would assigns the question_id
      @answer.question = @question

      # you can set user_id via object, it's recommended
      @answer.user = current_user

     # render json: params


     if @answer.save
       redirect_to question_path(@question), notice: "Thanks for answering"
     else
       flash[:alert] = "Answer is not saved"

       # Note: question_path is a URL, is not a template
       # this will render the show.html.erb inside views/questions
       render "/questions/show"
     end
  end

  def destroy
    # /questions/:question_id/answers/:id(.:format)
    # for question, it is question_id, for answer, it is just id


    question = Question.find params[:question_id]
    #answer = Answer.find params[:id]
    # if you want to make sure the answer is within the question
    # but usually our route should take care of that
    answer = question.answers.find params[:id]
    answer.destroy
    redirect_to question_path(question), notice: "Answer deleted!"

  end

end
