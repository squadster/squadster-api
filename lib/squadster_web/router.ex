defmodule SquadsterWeb.Router do
  use SquadsterWeb, :router

  alias SquadsterWeb.Plugs.Auth
  alias SquadsterWeb.Plugs.Context

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    scope "/" do
      pipe_through Context

      forward "/query", Absinthe.Plug.GraphiQL, schema: Squadster.Schema
    end

    scope "/", SquadsterWeb do
      scope "/auth" do
        get "/:provider", AuthController, :request
        get "/:provider/callback", AuthController, :callback
        delete "/", AuthController, :destroy, as: :logout
      end

      get "/ping", PingController, :ping
    end
  end
end
