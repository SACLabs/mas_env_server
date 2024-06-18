defmodule MasEnvServer.Repo do
  use Ecto.Repo,
    otp_app: :mas_env_server,
    adapter: Ecto.Adapters.Postgres
end
