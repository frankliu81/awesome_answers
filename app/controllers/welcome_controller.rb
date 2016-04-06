class WelcomeController < ApplicationController


    # this defines an 'action' called index for the 'WelcomeController'
    def index
      #render text: "Hello World!"
      # By default (convention) Rails will render:
      # views/welcome/index.html.erc (when receiving a request that has an HTML format)

      #  You could also call the default explicityly
      #render:index
      # or
      #render "/some_other_folder/some_other_action"

      # if you use another format by going to url such as '/home.txt'
      # Rails will render a template according to that format so in the case of
      # '/home.text' it will be:
      # views/welcome/index.text.erb
      # action doens't have to match the url name
    end

    def about
    end

end
