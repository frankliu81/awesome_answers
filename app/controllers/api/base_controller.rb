class Api::BaseController < ApplicationController
  before_action :authenticate_api_key

  private

    def authenticate_api_key
      # find the user through the api_key params
      # params[api_key]
      #
      # the api_key would match what we created for the user in the database,
      # and we will give that to the user for him/her to access the API http://localhost:3001/api/v1/questions?api_key=d1fafe23d67a1c230e5860fe98e138245c465e1d2982d545475c5027267a3e5f is now accessible

      @user = User.find_by(api_key: params[:api_key])
      head :unauthorized unless @user
    end

end
