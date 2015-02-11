DochiveMysql::Application.routes.draw do
  resources :markers

  resources :peaks

  resources :builders

  resources :tyndales

  resources :phases

  resources :languages

  resources :settings

  resources :data

  resources :assets

  resources :sections

  resources :pages

  resources :documents

  resources :types

  resources :templates

  resources :styles

  resources :groups

  devise_for :users do get '/users/sign_out' => 'devise/sessions#destroy' end

  resources :users
  
  get "hive/index"
  get "hive/overview"
  get "documents/separatePages"
  post "documents/exclude"
  post "documents/settemplate"
  post "documents/etalpmet"
  post "documents/addsection"
  post "documents/clearbuilder"
  post "documents/nametemplate"
  post "documents/selfie"

  #get "documents/deletePreviousOutput"
  
  #get "document/"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'hive#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  get '/documents/:id/pages' =>	'documents#pages' 
  get '/documents/:id/templates' =>	'documents#templates' 
  get '/documents/:id/convert' =>	'documents#convert' 
  get '/documents/:id/repage' =>	'documents#repage' 
  get '/documents/:id/tempbuilder' => 'documents#tempbuilder' 
  #get '/documents/:id/inspection' => 'documents#inspection' 
  get '/documents/inspection/:id' => 'documents#inspection' 
  get '/documents/:id/createtemplate' => 'documents#createtemplate' 

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
