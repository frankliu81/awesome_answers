class Admin::QuestionsController < ApplicationController

  def show
    render text: "admin/questions#show id=#{params[:id]}"
  end


  def index
    render text: "Inside Admin::QuestionsController index"
  end
  
end
