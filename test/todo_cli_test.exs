defmodule TodoCliTest do
  use ExUnit.Case, async: true
  alias TodoCli.Console
  doctest TodoCli
  import Mock
  import Main
  import Console

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TodoCli.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(TodoCli.Repo, {:shared, self()})
  end

  test "add_list/0" do
    list = TodoCli.add_list("My brand new list")

    assert list
  end

  test "remove_list/0" do
    TodoCli.add_list("trash list")
    list = TodoCli.remove_list("trash list")

    assert list
  end

  test "create_item/2" do
    TodoCli.add_list("my list for testing")
    item = TodoCli.create_item("my list for testing", "my test task")
    assert item == :ok
  end

  test "task_complete/0" do
    TodoCli.add_list("my list for testing")
    TodoCli.create_item("my list for testing", "my test task")
    item = TodoCli.get_item("my list for testing", "my test task") |> Enum.at(0)
    complete = TodoCli.task_complete(item)
    assert complete
  end

  test_with_mock "mark_task_done/0", TodoCli.Console, input: fn _input -> "my test task" end do
    TodoCli.add_list("my list for testing")
    item = TodoCli.create_item("my list for testing", "my test task")
    #      mark_task_done()
  end
end
