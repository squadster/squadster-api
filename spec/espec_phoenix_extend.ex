defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      alias Squadster.Repo
    end
  end

  def controller do
    quote do
      import SquadsterWeb.Router.Helpers
      import Squadster.Support.RequestsHelper

      alias Squadster.Repo

      @endpoint SquadsterWeb.Endpoint
    end
  end

  def view do
    quote do
      import SquadsterWeb.Router.Helpers
    end
  end

  def channel do
    quote do
      alias Squadster.Repo

      @endpoint SquadsterWeb.Endpoint
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
