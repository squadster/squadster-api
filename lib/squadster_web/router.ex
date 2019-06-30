defmodule SquadsterWeb.Router do
  use SquadsterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", SquadsterWeb do
    pipe_through :browser

    get "/", SessionController, :new, as: :root

    get "/auth/:provider/callback", SessionController, :create
    get "/auth/failure", SessionController, :failure_callback
    get "/signout", SessionController, :destroy, as: :signout

    resources "/users", UserController
  end
end
