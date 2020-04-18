defmodule ESpec.Phoenix.Extend do
  def model do
    quote do
      import Squadster.Support.Factory
      import Squadster.Support.RepoHelper

      alias Squadster.Repo
    end
  end

  def helper do
    quote do
      alias Squadster.Helpers
      alias Squadster.Repo
    end
  end

  def controller do
    quote do
      use Phoenix.ConnTest

      import SquadsterWeb.Router.Helpers
      import Squadster.Support.Factory
      import Squadster.Support.RequestsHelper
      import Squadster.Support.RepoHelper

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
