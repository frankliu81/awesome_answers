class AnswersController <  ApplicationController


  before_action :authenticate_user!
  before_action :find_question
  before_action :find_and_authorize_answer, only: :destroy

  #skip_before_action :authorize_question

  #include QuestionsAnswersHelper
  # cannot use helper_method inside concerns
  #helper_method :user_like

  def create
      # testing form submit button turning into submitting ...
      # with a sleep of 5
      # sleep 5
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

     respond_to do |format|

       if @answer.save
         #AnswersMailer.notify_question_owner(Answer.last).deliver_now
         AnswersMailer.notify_question_owner(Answer.last).deliver_later
         format.html {redirect_to question_path(@question), notice: "Thanks for answering"}
         #format.js { render js: "alert('success')" }
         format.js { render :create_success }
       else
         flash[:alert] = "Answer is not saved"

         # Note: question_path is a URL, is not a template
         # this will render the show.html.erb inside views/questions
         format.html {render "/questions/show"}
         #format.js { render js: "alert('failure')" }
         format.js { render :create_failure }
       end
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
    respond_to do |format|
      format.html { redirect_to question_path(@question), notice: "Answer deleted!"}
      format.js { render }
    end
  end

  def edit
    @answer = Answer.find params[:id]
  end

  def update
    @question = Question.find params[:question_id]
    @answer = Answer.find params[:id]
    answer_params = params.require(:answer).permit(:body)

    respond_to do |format|
      if @answer.update answer_params
        format.html { redirect_to question_path(@question), notice: "Answer updated" }
        format.js { render :update_success}
      else
        format.html { render :edit }
        format.js { render :update_failure}
      end
    end
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
