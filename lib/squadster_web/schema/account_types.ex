defmodule SquadsterWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias SquadsterWeb.Resolvers.Accounts, as: AccountsResolver

  object :user do
    field :id, non_null(:id)
    field :uid, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :birth_date, :date
    field :mobile_phone, :string
    field :university, :string
    field :faculty, :string
    field :small_image_url, :string
    field :image_url, :string
    field :vk_url, :string
    field :settings, :user_settings, resolve: dataloader(Squadster.Accounts)
    field :squad_request, :squad_request, resolve: dataloader(Squadster.Formations)
    field :squad_member, :squad_member, resolve: dataloader(Squadster.Formations)
  end

  object :current_user do
    field :hash_id, non_null(:string)

    import_fields(:user)
  end

  object :user_settings do
    field :vk_notifications_enabled, :boolean
    field :telegram_notifications_enabled, :boolean
    field :email_notifications_enabled, :boolean
  end

  object :accounts_queries do
    @desc "Get current user"
    field :current_user, :current_user do
      resolve &AccountsResolver.current_user/3
    end
  end

  object :accounts_mutations do
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

    @desc "Update user's settings"
    field :update_user_settings, type: :user_settings do
      arg :user_id, non_null(:id)
      arg :vk_notifications_enabled, :boolean
      arg :telegram_notifications_enabled, :boolean
      arg :email_notifications_enabled, :boolean

      resolve &AccountsResolver.update_user_settings/3
    end
  end
end
