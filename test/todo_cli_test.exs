defmodule TodoCliTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO
  doctest TodoCli

  import Main

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TodoCli.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(TodoCli.Repo, {:shared, self()})
  end

  test "add_list/0" do
    list = TodoCli.add_list("My brand new list")

    assert list == "Your list 'My brand new list' has been created!"
  end

  test "remove_list/0" do
    TodoCli.add_list("trash list")
    list = TodoCli.remove_list("trash list")

    assert list == "Deleted successfully"
  end

  test "create_item/2" do
    TodoCli.add_list("my list for testing")
    item = TodoCli.create_item("my list for testing", "my test task")
    assert item == :ok
  end

# Will revisit IO testing later
#  test "mark_task_done/0" do
#    TodoCli.add_list("my list for testing")
#    item = TodoCli.create_item("my list for testing", "my test task")
#    mark_task_done()
#  end


end
