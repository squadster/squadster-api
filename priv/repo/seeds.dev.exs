alias Squadster.Repo

alias Squadster.Accounts.User
alias Squadster.Formations.Squad
alias Squadster.Formations.SquadMember

for _ <- (1..30) do
  uid = Faker.Util.format("%9d")
  Repo.insert!(%User{
    first_name: Faker.Name.first_name,
    last_name: Faker.Name.last_name,
    birth_date: Faker.Date.date_of_birth(17..20),
    mobile_phone: "+375" <> Faker.Util.format("%9d"),
    university: "University of " <> Faker.Industry.sector,
    faculty: "Faculty of " <> Faker.Industry.sub_sector,
    uid: uid,
    auth_token: Faker.String.base64(85),
    small_image_url: Faker.Avatar.image_url,
    image_url: Faker.Avatar.image_url,
    vk_url: "https://vk.com/id" <> uid
  })
  #has_one :squad_member, Squadster.SquadMember
end

for _ <- (1..2) do
  Repo.insert!(%Squad{
    squad_number: Faker.Util.format("%6d"),
    advertisment: Faker.StarWars.quote,
    class_day: Faker.Util.pick([:monday, :twesday, :wednesday, :thursday, :friday, :saturday])
  })
  #has_many :squad_members, Squadster.Formations.SquadMember
end

squad = Repo.get(Squad, 1)

Repo.all(User)
|> Enum.slice(0, 15)
|> Enum.each fn user ->
  Repo.insert!(%SquadMember{
    role: Faker.Util.pick([:commander, :deputy_commander, :journalist, :student]), # TODO one
    user: user,
    squad: squad
  })
end

squad = Repo.get(Squad, 2)

Repo.all(User)
|> Enum.slice(15, 15)
|> Enum.each fn user ->
  Repo.insert!(%SquadMember{
    role: Faker.Util.pick([:commander, :deputy_commander, :journalist, :student]), # TODO one
    user: user,
    squad: squad
  })
end


#Enum.each squads, fn squad ->
  #Enum.each users, fn user ->
    #Repo.insert!(%SquadMember{
      #role: Faker.Util.pick([:commander, :deputy_commander, :journalist, :student]), # TODO one
      #user: Repo.get(User, user.id * squad.id),
      #squad: squad
    #})
  #end
#end
