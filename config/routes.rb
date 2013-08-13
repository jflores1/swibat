Swibat::Application.routes.draw do
  

  get "faculty/index"

  get "faculty/show"

  get "timeline", to: "timeline#index", as: :timeline

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match "search" => "search#index"

  root to: 'static_pages#home'

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  get "educational_standards/autocomplete_educational_standard_description", as: "autocomplete_educational_standard_description"

  post "invitations/send_invitation"
  
  get "answers/new"
  get "answers/edit"
  get "flags/flag"

  match 'teachers',       to: 'static_pages#teachers'
  match 'administrators', to: 'static_pages#administrators'
  match 'resources',      to: 'static_pages#resources'
  match 'pricing',        to: 'static_pages#pricing'
  match 'request-trial',  to: 'leads#new', as: "request_trial"
  match 'request-invite', to: 'static_pages#request_invite', as: "request_invite"

  get 'objectives/similar_objectiveables'

  resources :questions do
    resources :answers, :except => [:show, :index] do
      member { post :vote }
    end
    member { post :vote }
    collection do
      get 'tags/:tag', to: 'questions#index', as: :tag
    end
  end

  resources :leads
  resources :users do
    member do
      get :followers
      get :following
      get :followed_courses
      get :content_map
      get :followed_maps
      get :videos
      get :eval
      get :evaluations
      get :courses
    end
  end

  resources :posts do
    collection do
      get 'tags/:tag', to: 'posts#index', as: :tag
    end
  end

  resources :courses do
    resources :objectives
    resources :assessments
    resources :units
    resources :comments, :only => [:create, :destroy]
    member do
      post :vote
      post :fork
      get  :new_course_goal
      post :course_goal
      get 'syllabus'
      get :unit_calendar
      get :calendar
      get  :syllabus
      get  :journal
    end
    collection do
      get 'feed'
      get 'tags/:tag', to: 'courses#index', as: :tag
      get :course_maps
    end
  end

  resources :units do
    resources :objectives
    resources :assessments
    resources :lessons
    resources :comments, :only => [:create, :destroy]
    member do
      post :vote
      get :new_unit_content
      get :new_unit_skill
    end
  end

  resources :lessons do    
    resources :objectives
    resources :assessments
    resources :lesson_activities
    resources :comments, :only => [:create, :destroy]      
    
    member do
      post :vote
      get  :standards
      post :save_standards
      post :update_journal_entry
      get  :new_lesson_content
      get  :new_lesson_skill
      get  :videos
      get  :new_standard
      put  :add_standard
      post :remove_standard
    end    
  end

  resources :videos do  
    resources :comments, :only => [:create, :destroy]
    new do
       post :upload
       get  :save_video
     end
  end  

  resources :followings, :only => [:create, :destroy]

  resources :teacher_evaluations, only: [:show] do
    resources :comments, :only => [:create, :destroy]
  end

  resources :institutions do 
    get :autocomplete_institution_name, :on => :collection

    resources :evaluation_templates do
      resources :evaluation_domains do
        resources :evaluation_criteria do 

        end
      end
      collection do
        get :new_prepopulated_template
      end
    end

    resources :teacher_evaluations, only: [:index, :create, :show], :path => :evaluations, :as => :evaluations do
      resources :comments, :only => [:create, :destroy]
    end
    
    member do
      get :faculty
      get :eval_template
    end
  end

  resources :microposts, only: [:create, :index]
  
  match 'demo/:action' => 'demo#:action'
  match 'static_pages/:action' => 'static_pages#:action'

  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
