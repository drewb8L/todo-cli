defmodule TodoCliTest do
  use ExUnit.Case, async: true
  doctest TodoCli

  alias TodoCli.{List, ListItems}
  import Ecto.Query
  import TodoCli.Repo
  import Ecto.Changeset

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

    from(l in List, where: l.id == ^list.id, update: [set: [title: "Better title"]])
    |> TodoCli.Repo.update_all([])

    new_list = TodoCli.Repo.get!(List, list.id)
    assert new_list.id == list.id
  end

  test "delete list by name" do
    list = TodoCli.Repo.insert!(%List{title: "House chores"})

    result =
      case TodoCli.Repo.delete(list) do
        {:ok, struct} ->
          "Deleted successfully"

        {:error, _reason} ->
          "Error"
      end

    assert result == "Deleted successfully"
  end

  test "create list and associated task" do
    list = List.changeset(%List{}, %{title: "My new list"})

    list =
      if list.valid? do
        TodoCli.Repo.insert!(list)
      else
        list.errors
      end

    item = ListItems.changeset(%ListItems{}, %{task: "Order pizza for dinner", done: false})

    item =
      if item.valid? do
        TodoCli.Repo.insert!(item)
      else
        list.errors
      end

    ba = Ecto.build_assoc(list, :items, item)
    assert ba.list_id == list.id
  end

  test "add_list/1" do
    list = TodoCli.add_list("My new list that hasn't been created yet")

    assert list == "Your list 'My new list that hasn't been created yet' has been created!"
  end

  test "remove_list/1" do
    TodoCli.add_list("trash list")
    list = TodoCli.remove_list("trash list")

    assert list == "Deleted successfully"
  end

  test "create_item/2" do
    TodoCli.add_list("my list for testing")
    item = TodoCli.create_item("My test task", "my list for testing")
    assert item
  end
end
