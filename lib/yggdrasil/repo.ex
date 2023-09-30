defmodule Yggdrasil.Repo do
  use Ecto.Repo,
    otp_app: :yggdrasil,
    adapter: Ecto.Adapters.Postgres
end
