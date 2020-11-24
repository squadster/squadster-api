defmodule Squadster.Support.Factory do
  use ExMachina.Ecto, repo: Squadster.Repo

  use Squadster.Support.Factory.Accounts.UserFactory
  use Squadster.Support.Factory.Accounts.UeberauthFactory
  use Squadster.Support.Factory.Accounts.UserSettingsFactory
  use Squadster.Support.Factory.Formations.SquadFactory
  use Squadster.Support.Factory.Formations.SquadRequestFactory
  use Squadster.Support.Factory.Formations.SquadMemberFactory
  use Squadster.Support.Factory.Schedules.TimetableFactory
  use Squadster.Support.Factory.Schedules.LessonFactory
end
