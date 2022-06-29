defmodule TodoCli.Repo.Migrations.AddListItems do
  use Ecto.Migration

  def change do
    create table(:list_items) do
      add :task, :string
      add :list_id, references(:lists, on_delete: :delete_all)
    end
  create index(:list_items, [:list_id])
  end
end
