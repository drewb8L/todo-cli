defmodule TodoCli.Repo do
  use Ecto.Repo,
    otp_app: :todo_cli,
    adapter: Ecto.Adapters.Postgres
end
