import Ecto.Query
import Squadster.Support.Factory

alias Squadster.Repo
alias Squadster.Accounts.User
alias Squadster.Formations.Squad
alias Squadster.Formations.SquadMember

seeds_config = [
  users: 40,
  squads: 2,
  users_per_squad: 20, # should be greater than or equal to number of squad_member roles
  unapproved_users: 5
]

# create users
for _ <- (1..seeds_config[:users]), do: insert(:user)

# create squads
for _ <- (1..seeds_config[:squads]), do: insert(:squad)

# create users with upapproved squad request
for index <- (1..seeds_config[:unapproved_users]) do
  squad = Repo.get(Squad, 1)
  build(:user) |> with_squad_request_to_a_certain_squad(squad) |> insert
end

# connect users and squads
for index <- (1..seeds_config[:squads]) do
  squad = Repo.get(Squad, index)

  Repo.all(User)
  |> Enum.slice((index - 1) * seeds_config[:users_per_squad], seeds_config[:users_per_squad])
  |> Enum.each(fn user -> insert(:squad_member, user: user, squad: squad, role: :student) end)
end

# create squad requset for users with squad
Repo.all(User)
|> Repo.preload(squad_member: :squad)
|> Enum.each(fn user ->
  if squad_member = user.squad_member do
    build(:squad_request, user: user, squad: squad_member.squad)
    |> approved_by(squad_member)
    |> insert
  end
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

# set queue numbers for all except commanders
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
