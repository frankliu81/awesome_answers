class AnswersController <  ApplicationController


  before_action :authenticate_user!
  before_action :find_question
  before_action :find_and_authorize_answer, only: :destroy

  #skip_before_action :authorize_question

  #include QuestionsAnswersHelper
  # cannot use helper_method inside concerns
  #helper_method :user_like

  def create
      # you want to make sure the question exists first before you
      # create an answer with that question
      # find would throw an exception, and show a 4040 page
      # now in before_action
      # @question = Question.find params[:question_id]

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

    # now in before_action
    # @question = Question.find params[:question_id]

    #answer = Answer.find params[:id]
    # if you want to make sure the answer is within the question
    # but usually our route should take care of that

    # this is refactored to find_and_authorize_answer
    # redirect_to root_path unless can? :destroy, answer

    @answer.destroy
    redirect_to question_path(@question), notice: "Answer deleted!"

  end
private
  def find_question
    @question = Question.find params[:question_id]
  end

  def find_and_authorize_answer
    @answer = @question.answers.find params[:id]
    redirect_to root_path unless can? :destroy, @answer
    # we can also halt, it will give you a 401
    # head :unauthorized unless can? :destroy, @answer
  end

end
