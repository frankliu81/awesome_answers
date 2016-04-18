class QuestionsController < ApplicationController

  # defining a method in as a 'before_action' will make it so that Rails
  # exectues that method before executing the action.  This is still within
  # the same request cycle

  # find_question is not an actual action, it can be private
  # you can give the 'before_action' method two options: :only or :except
  # this will help you limit the actions which the 'find_question'method will
  # be exectued before.
  # in the code below 'find_quesiton' will only be executed before: show, edit
  # update and destroy actions
  #before_action :find_question, only: [:show, :edit, :update, :destroy]

  before_action :find_question, only: [:edit, :update, :destroy, :show]
  before_action :authorize_question, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def new
    # we need to define a new 'Question' object in order to be able to
    # properly generate a form in Rails
    @question = Question.new
  end

  def create
    # method 1
    # @question = Question.new
    # @question.title = params[:question][:title]
    # @question.body = params[:question][:body]
    # @question.save!

    # method 2
    # @question = Question.create({title: params[:question][:title],
    #                     body: params[:question][:body]})

    # method 3
    # params[:quesiton] looks like: {"title"=>"question from the web",
    # "body" =>"quesiton body from web"}
    # one problem with the code, activeModel::ForbiddenAttributesError
    # this worked in Rails 3
    # parameter injected IsAdmin through mass assignment, when IsAdmin
    # form isn't available

    # @question = Question.create(params[:question])

    # method 4 - strong parameters gem, part of Rails
    # other attributes not in permit would be ignored
    #questions_params = params.require(:question).permit([:title, :body])

    @question = Question.new(questions_params)

    # you can set user_id via object, it's recommended
    @question.user = current_user

    if @question.save
      flash[:notice] = "Question created!"
      #render text: "SUCCESS"
      # render :show will give take you to /questions
      # render :show
      # You need a redirect_to question_path({id: @question.id})
      redirect_to question_path(@question)

    else
      flash[:alert] = "Question didn't save!"
      # this will render 'app/views/questions/new.html.erb' because the default
      # in this section is to render the create, we did not have a create
      render :new
    end

  end

  # we receive a request such as: GET /questions/56
  # params[:id] will be '56'
  def show
    @answer = Answer.new
  end

  def index
    @questions = Question.all
  end

  def edit
    # we need to find the question in order to edit it
  end

  def update

    if @question.update questions_params
      # flash messages can be set either direclty using:
      #flash[:notice] = "..".  you can also pass a ':notice' or ':alert' options
      #to the 'redirect_to' method.
      redirect_to question_path(@question), notice: "Quesiton updated!"
    else
      # the bad value you enter will temporarily stay, it is a feature
      # of active record
      render :edit
    end

  end

  def destroy

    @question.destroy
    # do confirmation pop-up, redirect to index
    redirect_to questions_path, notice: "Question deleted!"
  end

  # from the routing assignment
  # def index
  #   render text: "questions#index"
  # end
  #
  # def delete
  #   puts "#{params.inspect}"
  #   puts "questions#delete id=#{params[:id]}";
  # end
  #
  # def edit
  # end

  # old show for routing assignment
  # def show
  #   puts "#{params.inspect}"
  #   puts "questions#show id=#{params[:id]}";
  #   render text: "questions#show id=#{params[:id]}"
  # end

  private

  # instance variable accessible, processed within the same request cycle
  def find_question
    @question = Question.find params[:id]

  end

  def authorize_question
    redirect_to root_path unless can? :manage, @question
  end

  # local variable and local variable are the same
  def questions_params
    # strong parameters, prevent user from injecting unwanted parameters
    params.require(:question).permit(:title, :body, :category_id)
  end

end
