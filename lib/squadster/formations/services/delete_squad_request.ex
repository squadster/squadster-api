defmodule Squadster.Formations.Services.DeleteSquadRequest do
  import Mockery.Macro
  import SquadsterWeb.Gettext

  alias Squadster.Repo
  alias Squadster.Formations.Squad
  alias Squadster.Accounts.User

  def call(squad_request) do
    squad_request
    |> Repo.delete
    |> notify_user
  end

  defp notify_user({:error, _} = result), do: result
  defp notify_user({:ok, %{user_id: user_id, squad_id: squad_id}} = result) do
    %{squad_number: squad_number} = Squad |> Repo.get(squad_id)

    mockable(Squadster.Accounts.Tasks.Notify).start_link([
      message: gettext("Your request to squad %{squad_number} was approved!", squad_number: squad_number),
      target: %User{id: user_id},
    ])

    result
  end
end
