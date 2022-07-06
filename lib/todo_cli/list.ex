defmodule TodoCli.List do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "lists" do
    field(:title, :string)
    has_many(:items, TodoCli.ListItems)
  end

  def changeset(list, attrs \\ %{}) do
    list
    |> cast(attrs, [:title])
    |> unique_constraint(:title, message: "This title name is already in use, please choose a different name.")
    |> validate_required([:title])
  end
end
