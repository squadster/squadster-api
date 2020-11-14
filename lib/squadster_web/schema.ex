defmodule Squadster.Schema do
  use Absinthe.Schema

  alias SquadsterWeb.Resolvers.Accounts, as: AccountsResolver
  alias SquadsterWeb.Resolvers.Formations, as: FormationsResolver
  alias SquadsterWeb.Resolvers.Schedules, as: SchedulesResolver
  alias Squadster.{Accounts, Formations, Schedules}

  import_types SquadsterWeb.Schema.{SharedTypes, AccountTypes, FormationTypes, SchedulesTypes}

  query do
    @desc "Get current user"
    field :current_user, :current_user do
      resolve &AccountsResolver.current_user/3
    end

    # TODO: rebuild permissions
    @desc "Get a list of squads"
    field :squads, list_of(:squad) do
      resolve &FormationsResolver.squads/3
    end
  end

  mutation do
    @desc "Update current user"
    field :update_current_user, type: :user do
      arg :first_name, :string
      arg :last_name, :string
      arg :birth_date, :date
      arg :mobile_phone, :string
      arg :university, :string
      arg :faculty, :string

      resolve &AccountsResolver.update_current_user/3
    end

    @desc "Create a squad"
    field :create_squad, type: :squad do
      arg :squad_number, non_null(:string)
      arg :advertisment, :string
      arg :class_day, non_null(:integer)
      arg :link_invitations_enabled, :boolean

      resolve &FormationsResolver.create_squad/3
    end

    @desc "Update a squad"
    field :update_squad, type: :squad do
      arg :id, non_null(:id)
      arg :squad_number, :string
      arg :advertisment, :string
      arg :class_day, :integer
      arg :link_invitations_enabled, :boolean

      resolve &FormationsResolver.update_squad/3
    end

    @desc "Delete a squad"
    field :delete_squad, type: :squad do
      arg :id, non_null(:id)

      resolve &FormationsResolver.delete_squad/3
    end

    @desc "Create a squad_request"
    field :create_squad_request, type: :squad_request do
      arg :squad_id, non_null(:id)

      resolve &FormationsResolver.create_squad_request/3
    end

    @desc "Approve a squad_request"
    field :approve_squad_request, type: :squad_member do
      arg :id, non_null(:id)

      resolve &FormationsResolver.approve_squad_request/3
    end

    @desc "Delete/decline a squad_request"
    field :delete_squad_request, type: :squad_request do
      arg :id, non_null(:id)

      resolve &FormationsResolver.delete_squad_request/3
    end

    @desc "Update a squad_member"
    field :update_squad_member, type: :squad_member do
      arg :id, non_null(:id)
      arg :queue_number, :integer
      arg :role, :string

      resolve &FormationsResolver.update_squad_member/3
    end

    @desc "Update a batch of squad_members"
    field :update_squad_members, type: list_of(:squad_member) do
      arg :batch, list_of(:squad_members_batch)

      resolve &FormationsResolver.update_squad_members/3
    end

    @desc "Delete a squad_member"
    field :delete_squad_member, type: :squad_member do
      arg :id, non_null(:id)

      resolve &FormationsResolver.delete_squad_member/3
    end

    @desc "Create a timetable"
    field :create_timetable, type: :timetable do
      arg :date, type: :date
      arg :squad_id, non_null(:id)

      resolve &SchedulesResolver.create_timetable/3
    end

    @desc "Delete timetable"
    field :delete_timetable, type: :timetable do
      arg :timetable_id, non_null(:id)

      resolve &SchedulesResolver.delete_timetable/3
    end

    @desc "Update existing timetable"
    field :update_timetable, type: :timetable do
      arg :timetable_id, non_null(:id)
      arg :date, type: :date

      resolve &SchedulesResolver.update_timetable/3
    end

    @desc "Create a lesson"
    field :create_lesson, type: :lesson do
      arg :timetable_id, non_null(:id)
      arg :name, :string
      arg :teacher, :string
      arg :index, :integer
      arg :note, :string

      resolve &SchedulesResolver.create_lesson/3
    end

    @desc "Delete a lesson"
    field :delete_lesson, type: :lesson do
      arg :index, non_null(:integer)
      arg :timetable_id, non_null(:id)

      resolve &SchedulesResolver.delete_lesson/3
    end

    @desc "Update a lesson"
    field :update_lesson, type: :lesson do
      arg :timetable_id, non_null(:id)
      arg :current_index, non_null(:integer)
      arg :name, :string
      arg :teacher, :string
      arg :index, :integer
      arg :note, :string

      resolve &SchedulesResolver.update_lesson/3
    end
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
