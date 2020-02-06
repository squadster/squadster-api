defmodule SquadsterWeb.Plugs.Context do
  @moduledoc """
  Authorize user and assign GraphQL context if it's data request, skip otherwise
  """

  @behaviour Plug

  alias SquadsterWeb.Plugs.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.method == "POST" do
      conn = Auth.call(conn, %{})
      Absinthe.Plug.put_options(conn, context: %{current_user: conn.assigns[:current_user]})
    else
      conn
    end
  end
end
