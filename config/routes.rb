Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :todos
  root "todos#index"

  namespace :api do
    post "subtasks/:parent_id", to: "subtasks#create"
  end

  post "/graphql", to: "graphql#execute"
  get "/graphql-demo", to: "graphql_demo#index"
  
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
end
