import Config

config :todo_cli, TodoCli.Repo,
  database: "todo_cli_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :todo_cli,
  ecto_repos: [TodoCli.Repo]
