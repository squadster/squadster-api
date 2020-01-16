defmodule SquadsterWeb.Router do
  use SquadsterWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", SquadsterWeb do
    pipe_through :api

    get "/:provider", SessionController, :request
    get "/:provider/callback", SessionController, :callback
    post "/:provider/callback", SessionController, :callback
    post "/logout", SessionController, :destroy, as: :logout
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: Squadster.Schema
  end
end
