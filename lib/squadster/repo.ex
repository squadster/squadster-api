defmodule Squadster.Repo do
  use Ecto.Repo,
    otp_app: :squadster,
    adapter: Ecto.Adapters.Postgres
end
