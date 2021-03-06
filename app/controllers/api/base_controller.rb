class Api::BaseController < ApplicationController
  # contra the other controller, if we don't pass in an authenticity token, any cookies will be cleared.
  protect_from_forgery with: :null_session
  # post request, you need to send authentication token by rails
  # if you don't send, rails will throw an exception, request will throw
  # make it a null session, if you have to authenticate the user, you will
  # authenticate with the api key, so the user won't logged in.
  before_action :authenticate_api_key
o
  private

    def authenticate_api_key
      # find the user through the api_key params
      # params[api_key]
      #
      # the api_key would match what we created for the user in the database,
      # and we will give that to the user for him/her to access the API http://localhost:3000/api/v1/questions?api_key=d1fafe23d67a1c230e5860fe98e138245c465e1d2982d545475c5027267a3e5f is now accessible

      @user = User.find_by(api_key: params[:api_key])
      head :unauthorized unless @user
    end

end
