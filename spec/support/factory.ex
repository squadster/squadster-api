defmodule Squadster.Support.Factory do
  use ExMachina.Ecto, repo: Squadster.Repo

  use Squadster.Support.Factory.UserFactory
  use Squadster.Support.Factory.SquadFactory
  use Squadster.Support.Factory.SquadRequestFactory
  use Squadster.Support.Factory.SquadMemberFactory
end
