class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate_api_key
  # params[api_key]
  #
  # the api_key would match what we created for the user in the database,
  # and we will give that to the user for him/her to access the API http://localhost:3001/api/v1/questions?api_key=d1fafe23d67a1c230e5860fe98e138245c465e1d2982d545475c5027267a3e5f is now accessible

  def index
    @questions = Question.order("created_at DESC").limit(10)
    render json: @questions
  end

  def show
    @question  = Question.find(params[:id])
    render json: @question
  end

  private
    def authenticate_api_key
      # find the user through the api_key params
      @user = User.find_by(api_key: params[:api_key])
      puts "<<<<<<<<<<< authenticate_api_key api_key: #{params[:api_key]} user: #{@user.id}"
      head :unauthorized unless @user
    end
end
