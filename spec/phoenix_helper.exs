Code.require_file("spec/espec_phoenix_extend.ex")

Ecto.Adapters.SQL.Sandbox.mode(Squadster.Repo, :manual)

Application.ensure_all_started(:bypass)
