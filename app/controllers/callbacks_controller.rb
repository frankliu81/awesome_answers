class CallbacksController < ApplicationController

  def twitter
    # search for the user with their uid/provider, if we find them then we log the user in and otherwise we create a new user account
    omniauth_data = request.env['omniauth.auth']
    user = User.where(provider: "twitter", uid: omniauth_data["uid"]).first
    if user
      sign_in(user)
      redirect_to root_path, flash: {success: "Signed In" }
    else
      user = User.create_from_twitter(omniauth_data)
      # byebug
      sign_in(user)
      redirect_to root_path, flash: {success: "Signed In" }
      # render json: omniauth_data
    end
  end

end
