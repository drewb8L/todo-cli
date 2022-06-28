defmodule TodoCliTest do
  use ExUnit.Case, async: true
  doctest TodoCli

  alias TodoCli.List
  import Ecto.Query
  import TodoCli.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TodoCli.Repo)
  end

  test "insert list" do
    list = TodoCli.Repo.insert!(%List{title: "My new list"})
    new_list = TodoCli.Repo.get!(List, list.id)
    assert new_list.title == "My new list"
  end
end
