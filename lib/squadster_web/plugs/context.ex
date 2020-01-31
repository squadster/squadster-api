defmodule SquadsterWeb.Plugs.Context do
  @behaviour Plug

  alias SquadsterWeb.Plugs.Auth

  def init(opts), do: opts

  @doc "Authorize user and assign GraphQL context if it's data request, skip otherwise"
  def call(conn, _opts) do
    if conn.method == "POST" do
      conn = Auth.call(conn, %{})
      Absinthe.Plug.put_options(conn, context: conn.assigns[:current_user])
    end
    conn
  end
end
