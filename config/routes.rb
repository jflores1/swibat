Swibat::Application.routes.draw do
  
  match "search" => "search#index"

  root to: 'static_pages#request_invite'

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

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
    member { get :followers }
    member { get :following }
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
    end
    collection do
      get 'feed'
      get 'tags/:tag', to: 'courses#index', as: :tag
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
    resources :activities
    resources :comments, :only => [:create, :destroy]    
    member do
      post :vote
      post :lesson_content
      post :lesson_skills
      get  :standards
      post :save_standards
    end    
  end

  resources :followings, :only => [:destroy] do
    member do
      post 'follow'
    end
  end

  resources :microposts, only: :create
  
  match 'demo/:action' => 'demo#:action'
  match 'static_pages/:action' => 'static_pages#:action'


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
