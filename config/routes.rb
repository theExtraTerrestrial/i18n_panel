I18nPanel::Engine.routes.draw do
  resources :translations

  root to: 'translations#index'
end
