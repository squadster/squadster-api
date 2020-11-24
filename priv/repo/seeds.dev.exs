import Ecto.Query
import Squadster.Support.Factory

alias Squadster.Repo
alias Squadster.Accounts.User
alias Squadster.Formations.Squad
alias Squadster.Formations.SquadMember
alias Squadster.Schedules.Timetable

seeds_config = [
  users: 40,
  squads: 2,
  unapproved_users: 5, # for each squad in addition to users number above
  timetables_per_squad: 4,
  lessons_per_timetable: 4
] # users / squads should be >= 3

for _ <- (1..seeds_config[:users]),  do: insert(:user)  # create users
for _ <- (1..seeds_config[:squads]), do: insert(:squad) # create squads

# connect users and squads
users_per_squad = (seeds_config[:users] / seeds_config[:squads]) |> floor
for index <- (1..seeds_config[:squads]) do
  squad = Repo.get(Squad, index)

  Repo.all(User)
  |> Enum.slice((index - 1) * users_per_squad, users_per_squad)
  |> Enum.each(fn user -> insert(:squad_member, user: user, squad: squad, role: :student) end)
end

# add timetables to squads
Squad
|> Repo.all
|> Enum.each(fn squad ->
  for _ <- (1..seeds_config[:timetables_per_squad]) do
    build(:timetable)
    |> with_squad(squad)
    |> insert
  end
end)

# add lessons to timetables
Timetable
|> Repo.all
|> Enum.each(fn timetable ->
  for _ <- (1..seeds_config[:lessons_per_timetable]), do: insert(:lesson, timetable_id: timetable.id)
end)

# mark first 3 members as main roles
Repo.all(Squad)
|> Repo.preload(:members)
|> Enum.each(fn squad ->
  for index <- (0..2) do
    squad.members
    |> Enum.at(index)
    |> Ecto.Changeset.change(%{role: index})
    |> Repo.update()
  end
end)

# create approved squad requsets for users
Repo.all(User)
|> Repo.preload(squad_member: :squad)
|> Enum.each(fn user ->
  if squad_member = user.squad_member do
    build(:squad_request, user: user, squad: squad_member.squad)
    |> approved_by(Squad.commander(squad_member.squad))
    |> insert
  end
end)

# set correct queue numbers for all except commanders
Repo.all(Squad)
|> Repo.preload(:members)
|> Enum.each(fn squad ->
  members = from(m in SquadMember, where: m.squad_id == ^squad.id and m.role in [2, 3]) |> Repo.all()
  for index <- (0..Enum.count(members) - 1) do
    members
    |> Enum.at(index)
    |> Ecto.Changeset.change(%{queue_number: index + 1})
    |> Repo.update()
  end
end)

# create additional users with unapproved squad requests to existing squads
Repo.all(Squad) |> Enum.each(fn squad ->
  for _ <- (1..seeds_config[:unapproved_users]) do
    build(:user) |> with_request_to_squad(squad) |> insert
  end
end)
