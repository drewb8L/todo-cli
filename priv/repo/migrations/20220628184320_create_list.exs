defmodule TodoCli.Repo.Migrations.CreateList do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string

    end

  end
end
