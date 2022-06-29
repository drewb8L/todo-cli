defmodule TodoCliTest do
  use ExUnit.Case, async: true
  doctest TodoCli

  alias TodoCli.List
  import Ecto.Query
  import TodoCli.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TodoCli.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(TodoCli.Repo, {:shared, self()})
  end

  test "insert list" do
    list = TodoCli.Repo.insert!(%List{title: "My new list"})
    new_list = TodoCli.Repo.get!(List, list.id)
    assert new_list.title == "My new list"
  end

  test "retrieve a list by name" do
    cs = TodoCli.List.changeset(%List{}, %{title: "My other new list"})
    TodoCli.Repo.insert!(cs)
    list = TodoCli.Repo.get_by!(List, title: "My other new list")
    assert list.title == "My other new list"
  end

  test "Update list name" do
    list = TodoCli.Repo.insert!(%List{title: "My poorly named list"})
    bad_list = TodoCli.Repo.get!(List, list.id)
    IO.inspect bad_list
    from(l in List, where: l.id == ^list.id, update: [set: [title: "Better title"]])
    |> TodoCli.Repo.update_all([])
    new_list = TodoCli.Repo.get!(List, list.id)
    assert new_list.id == list.id
  end

  test "delete list by name" do
    list = TodoCli.Repo.insert!(%List{title: "House chores"})
    result = case TodoCli.Repo.delete(list) do
      {:ok, struct}  ->
      "Deleted successfully"

      {:error, _reason} ->
      "Error"
    end
    assert result == "Deleted successfully"
  end
end
