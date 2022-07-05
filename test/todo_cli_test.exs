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
