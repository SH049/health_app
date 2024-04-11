Rails.application.routes.draw do
  root to: 'home#top'
  resources :diaries
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
