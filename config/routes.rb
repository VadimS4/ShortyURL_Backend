Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'link#index'
  get '/:short_url', to: 'link#show'
  get 'shorten/:short_url', to: "link#shorten", as: :shorten
  post '/create', to: 'link#create'
  delete '/delete/:short_url', to: "link#delete"
  # get '/link/fetch_original_url'

end
