Cpshme::Application.routes.draw do
  

resources :coupons, :only => [ :new, :create, :expired ,:impressum] do
resources :views, :only => [ :index, :show ]
  end
  
  # Password paths
  match '/c/:url_token' => 'coupons#show'
  match '/c' => 'coupons#new'
  match '/expired' => 'coupons#expired'
 match '/impressum' => 'coupons#impressum'
  
  

  root :to => 'coupons#new'
  
  
end
