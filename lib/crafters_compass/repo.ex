defmodule CraftersCompass.Repo do
  use Ecto.Repo,
    otp_app: :crafters_compass,
    adapter: Ecto.Adapters.Postgres
end
