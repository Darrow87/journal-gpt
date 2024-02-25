Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Root path set to the entries index action
  root 'entries#index'

  # Resourceful routes for entries
  resources :entries

  # If you have additional actions beyond the standard CRUD operations,
  # you can define them within the `resources :entries` block.
  # For example, a custom route for generating an entry based on ChatGPT response:
  # resources :entries do
  #   member do
  #     get :generate_response
  #   end
  # end

  # You can also add custom routes for specific pages or actions outside of the standard RESTful routes.
  # For example, a route to a page where users can see their profile or dashboard (assuming you have a UsersController):
  # get 'profile', to: 'users#show'

  # Make sure to define routes for any additional controllers or actions you add to your app.
end
