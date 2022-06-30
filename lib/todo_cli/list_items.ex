defmodule TodoCli.ListItems do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "list_items" do
    field(:task, :string)
    field(:done, :boolean)
    belongs_to(:list, TodoCli.List)
  end

  def changeset(list_item, attrs \\ %{}) do
    list_item
    |> cast(attrs, [:task, :done, :list_id])
    |> validate_required([:task])
  end
end
