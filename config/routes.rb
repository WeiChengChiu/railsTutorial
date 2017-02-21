Rails.application.routes.draw do

  resources :events do
    resources :attendees, :controller => "event_attendees"

    collection do
      get :latest

      post :bulk_delete
    end
  end

  resources :people
  get "/welcome/say_hello" => "welcome#say"

  get "welcome" => "welcome#index"

  root "welcome#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
