import Ecto.Query
import Squadster.Support.Factory
import SquadsterWeb.Gettext

alias Squadster.Repo

alias Squadster.Workers
alias Squadster.Workers.NotifyDuties
alias Squadster.Workers.ShiftQueues

alias Squadster.Accounts
alias Squadster.Accounts.{User, UserSettings}
alias Squadster.Accounts.Tasks.Notify
alias Squadster.Accounts.Services.{
  UpdateUser,
  CreateUserSettings,
  UpdateUserSettings
}

alias Squadster.Formations
alias Squadster.Formations.{Squad, SquadRequest, SquadMember}
alias Squadster.Formations.Tasks.NormalizeQueue
alias Squadster.Formations.Services.{
  CreateSquad,
  UpdateSquad,
  CreateSquadMember,
  UpdateSquadMember,
  DeleteSquadMember,
  CreateSquadRequest,
  ApproveSquadRequest,
  DeleteSquadRequest,
  NotifySquadChanges
}

alias Squadster.Schedules
alias Squadster.Schedules.{Lesson, Timetable}
alias Squadster.Schedules.Services.{
  CreateLesson,
  UpdateLesson,
  DeleteLesson,
  CreateTimetable,
  UpdateTimetable
}

alias Squadster.Helpers
alias Squadster.Helpers.{Dates, Permissions}
