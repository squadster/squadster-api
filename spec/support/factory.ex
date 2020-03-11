defmodule Squadster.Factory do
  use ExMachina.Ecto, repo: Squadster.Repo
  use Squadster.UserFactory
  use Squadster.SquadFactory
  use Squadster.SquadRequestFactory
  use Squadster.SquadMemberFactory
end
