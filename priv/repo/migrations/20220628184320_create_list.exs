defmodule TodoCli.Repo.Migrations.CreateList do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string

    end
    create unique_index(:lists, [:title])
  end
end
