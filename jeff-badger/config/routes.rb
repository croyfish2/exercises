Rails.application.routes.draw do
  get 'prospects/index'
  root 'prospects#index'
end
