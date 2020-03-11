Code.require_file("spec/espec_phoenix_extend.ex")

Ecto.Adapters.SQL.Sandbox.mode(Squadster.Repo, :manual)

Faker.start()

Application.ensure_all_started(:bypass)
Application.ensure_all_started(:ex_machina)
