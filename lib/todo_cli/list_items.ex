defmodule TodoCl.ListItems do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "lists" do
    field(:task, :string)
    belongs_to(:list, TodoCli.List)
  end
end
