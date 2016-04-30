class PasswordResetsController < ApplicationController
  def new
  end

  def create
    # any find_by_<any_model_field> is avaialble through meta programming
    user = User.find_by_email params[:email]
    # generate the token, set the expiry date, send the e-mail to the user
    # these are the Instructions
    if user
      user.generate_password_reset_data
      PasswordResetsMailer.send_instructions(user).deliver_later
    end

  end

  def edit
    # maybe a good idea to have a user record handy
    # bang will throw an exception if not found, 404 error will be thrown
    @user = User.find_by_password_reset_token! params[:id]
  end

  def update
    # is it still params :id for the token, yes
    # we can check if password token has expired
    user_params = params.require(:user).permit(:password, :password_confirmation)
    @user = User.find_by_password_reset_token! params[:id]
    if @user.password_reset_expired?
      redirect_to new_password_reset_path, alert: "Password reset expired, try again"
    elsif @user.update user_params
      sign_in(@user)
      redirect_to root_path notice: "Password was reset successfully!"
    else
      render :edit
    end
  end

end
