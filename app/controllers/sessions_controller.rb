class SessionsController < ApplicationController

  before_action :redirect_if_loggedin, only: [:new, :create]
  def new
    # render the sign in page
  end

  def create

    user = User.find_by_email params[:email]

    if user && user.authenticate(params[:password])
      # sign user in
      sign_in(user)
      redirect_to root_path, notice: "Signed In!"
    else
      flash[:alert] = "Wrong Credentials!"
      render :new
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out!"
  end

  private

  def redirect_if_loggedin
    redirect_to root_path, notice: "Already logged in" if user_signed_in?
  end

end
