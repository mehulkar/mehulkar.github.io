Blog::Application.routes.draw do
  root to: 'static_pages#home'
  resources :posts
  match "/writes" => 'posts#index'
end
