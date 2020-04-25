Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/:short_url', to: 'link#show'
  post '/create', to: 'link#create'

end
