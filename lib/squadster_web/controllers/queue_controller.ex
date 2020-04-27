# This should be removed

defmodule SquadsterWeb.QueueController do
  use SquadsterWeb, :controller

  alias Squadster.Repo
  alias Squadster.Accounts.User

  def queue_number(conn, %{"uid" => uid}) do
    %{squad_member: %{queue_number: queue_number}} =
      User
      |> Repo.get_by(uid: uid)
      |> Repo.preload(:squad_member)

    conn
    |> put_status(:ok)
    |> json(%{queue_number: queue_number})
  end
end
