defmodule Squadster.Support.Factory do
  use ExMachina.Ecto, repo: Squadster.Repo

  use Squadster.Support.Factory.UeberauthFactory
  use Squadster.Support.Factory.Accounts.UserFactory
  use Squadster.Support.Factory.Formations.SquadFactory
  use Squadster.Support.Factory.Formations.SquadRequestFactory
  use Squadster.Support.Factory.Formations.SquadMemberFactory
end
