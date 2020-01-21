defmodule SquadsterWeb.Router do
  use SquadsterWeb, :router

  alias SquadsterWeb.Plugs.Auth

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    scope "/" do
      pipe_through Auth

      forward "/query", Absinthe.Plug.GraphiQL, schema: Squadster.Schema
    end

    scope "/", SquadsterWeb do
      scope "/auth" do
        get "/:provider", SessionController, :request
        get "/:provider/callback", SessionController, :callback
        delete "/", SessionController, :destroy, as: :logout
      end

      get "/ping", PingController, :ping
    end
  end
end
