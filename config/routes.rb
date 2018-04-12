Rails.application.routes.draw do
  get 'todo_lists/:todo_list_id/tags/:tag', to: 'todo_lists#show', as: :tag
  get 'todo_lists/:todo_list_id/typeahead/:query' => 'todo_items#typeahead'
  resources :todo_lists do
  	resources :todo_items do
        member do
          patch :complete,:incomplete,:efficiency
        end
    end
  end
  resources :indicators do
    collection { post :sort }
  end 
  resources :documentations
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :kpis
  devise_for :users
  root "indicators#index"

end
