class ContactUsController < ApplicationController
  # you can specify a different layout than the default by adding a line:
  # layout "special"

  def new
    Rails.logger.info ">>>>>>>>>>>>>>>>>>>>"
    Rails.logger.info ">>>>>>>>>>>>>>>>>>>>"
    # most ruby object will implement inspect
    Rails.logger.info request.inspect
    # request comes from ActionDispatch
    Rails.logger.info request.path
    # render :new, layout: "special";
  end

  # we defined this as the action in the route "contat_us#create"
  def create
    # rails with indifferent access, can be accessed with string or symbol
    #@name = params["full_name"]
    @name = params[:full_name]
  end

end
