Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
	resources :opes, only: [:index]
	root to: "opes#index"
end