defmodule Squadster.Schema do
  use Absinthe.Schema

  alias Squadster.{Accounts, Formations, Schedules}

  import_types SquadsterWeb.Schema.{SharedTypes, AccountTypes, FormationTypes, SchedulesTypes}

  query do
    import_fields :accounts_queries
    import_fields :formations_queries
  end

  mutation do
    import_fields :accounts_mutations
    import_fields :formations_mutations
    import_fields :timetables_mutations
  end

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Accounts, Accounts.data())
      |> Dataloader.add_source(Formations, Formations.data())
      |> Dataloader.add_source(Schedules, Schedules.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
