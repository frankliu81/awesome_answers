class QuestionsController < ApplicationController

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
    questions_params = params.require(:question).permit([:title, :body])
    @question = Question.new(questions_params)

    if @question.save
      #render text: "SUCCESS"
      # render :show will give take you to /questions
      # render :show
      # You need a redirect_to question_path({id: @question.id})
      redirect_to question_path(@question)

    else
      # this will render 'app/views/questions/new.html.erb' because the default
      # in this section is to render the create, we did not have a create
      render :new
    end

  end

  # we receive a request such as: GET /questions/56
  # params[:id] will be '56'
  def show
    @question = Question.find params[:id]
  end

  def index
    @questions = Question.all
  end

  def edit
    # we need to find the question in order to edit it
    @question = Question.find params[:id]
  end

  def update
    @question = Question.find params[:id]
    # we need similar technique with strong parameters
    question_params = params.require(:question).permit(:title, :body)
    if @question.update question_params
      redirect_to question_path(@question)
    else
      # the bad value you enter will temporarily stay, it is a feature
      # of active record
      render :edit
    end

  end

  def destroy
    @question = Question.find params[:id]
    @question.destroy
    # do confirmation pop-up, redirect to index
    redirect_to questions_path
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


end
