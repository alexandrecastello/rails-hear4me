Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # Records routes
  get 'analyse_text', to: 'records#analyse_text'
  get 'analyse_audio', to: 'records#analyse_audio'

  resources :records, only: %i[new show create index]
end
