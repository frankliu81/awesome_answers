Rails.application.routes.draw do


  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  resources :password_resets, only: [:new, :create, :edit, :update]
  
  # this defines a route so that when we receive a GET request with url: /home
  # Rails will invoke the WelcomeController with 'index' action
  # method call get, that takes in an argument which is a hash
  #get ({"/home" => "wecome#index"})
  # if we don't speicfy a helper method name it will default in this case
  # to 'home_path' and 'home_url'

  get "/home" => "welcome#index"

  # for this route we will have helper methods: about_us_path and about_us_url
  # that maps to "/about" and "/about" can be change to anything
  # and it will still work
  get "/about" => "welcome#about",  as: :about_us

  # routes are just rules
  get "/contact_us" => "contact_us#new"

  post "/contact_us" => "contact_us#create" # this will have the same helper
                                            # method as the route above because
                                            # they have the same URL "/contact_us"


  # # questions routes, intro to crud
  # get "/questions/new"        => "questions#new"    , as: :new_question
  # post "/questions"           => "questions#create" , as: :questions
  #
  # # following REST standard, it is best to include id in the URL
  # get "/questions/:id"        => "questions#show"   , as: :question
  #
  # # i have already defined the helper for /questions for the post, no need to
  # # define it
  # get "/questions"            => "questions#index"
  #
  # # if i want to show a question to edit, i need question id
  # get "/questions/:id/edit"   => "questions#edit"   , as: :edit_question
  #
  # patch "questions/:id"       => "questions#update"
  #
  # delete "/questions/:id"     => "questions#destroy"

  # shortchut, it generated the shortcuts by convention
  resources :questions

  # example of adding search routes
  # in rails/info/Routes
  # search_questions_path, path /questions/search (.:format) html, JSON
    # when you want to have a url that is not specific to one record
    # it returns a collection
  # search_question_path /questions/:id/search
    # similar to editing a specific question, searching within a question's detail
  # question_search_path
    # nested resource, something that is not directly related to question_search_path
    # but it is nested, you are not doing something specific to a question
    # but you are referencing a question
  # resources :questions do
  #   get :search, on: :collection
  #   get :search, on: :member
  #   get :search
  # end

  # the answers routes will be the standard ones prefixed within
  # /questions/:question_id
  # this way when we want to create an answer we know the question it references
  # all the helpers will be the same as befor prefixed with 'question_'

  resources :questions do
    resources :answers, only: [:create, :destroy]

    resources :likes, only: [:create, :destroy]

    resources :votes, only: [:create, :update, :destroy]
  end

  resources :users, only: [:new, :create]

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
    #delete :destroy, on: :member # same one as the default generated
    #delete :destroy # includes the session_id
  end



  # Routes exercise
  # new (doesn't save anything, ask for a form)
  # create
  # edit (ask for the form)
  # update
  # index, get all
  # show, get one
  # destroy
  # create question controller, put a delete method

  # delete "/questions/:id" => "questions#delete",  as: :delete_question
  #
  # get "/questions/:id/edit" => "questions#edit"
  #
  # get "/questions/:id" => "questions#show"
  #
  # post "/questions/:id/comments" => "comments#create"
  #
  # get "/faq" => "home#faq"

  # manually do the path to controller in a folder
  #get "/admin/questions" => "admin/questions#index"

  # http://guides.rubyonrails.org/routing.html
  # automatically do the path to controller in a folder
  # namespace :admin do
  # 	#resources :questions, only: [:index]
  #   resources :questions
  # end

  # alternatively, do the path differently
  #get "/admin/questions" => "questions#index"

  # automatically
  scope '/admin' do
    resources :questions
  end

  # this defines the 'root' or home page or our applicaiton to go to the
  # WelcomeController with 'index' action.  We will have access to
  # the helper# methods: root_path and root_url
  root "welcome#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
