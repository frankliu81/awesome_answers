class QuestionsController < ApplicationController

  def index
    render text: "questions#index"
  end

  def delete
    puts "#{params.inspect}"
    puts "questions#delete id=#{params[:id]}";
  end

  def edit

  end

  def show
    puts "#{params.inspect}"
    puts "questions#show id=#{params[:id]}";
    render text: "questions#show id=#{params[:id]}"
  end


end
