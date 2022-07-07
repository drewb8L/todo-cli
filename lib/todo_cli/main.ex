defmodule Main do
  def create_list() do
    list =
      IO.gets("Create a new list: ")
      |> String.trim()
    try do
      new_list = TodoCli.add_list(list)
      title = new_list.changes[:title]
      TodoCli.create_item(title, IO.gets("Create an item: "))
      rescue
      e in UndefinedFunctionError ->
        IO.puts("There seems to be a problem, that task doesn't exist" <> e.message)

      e in ArgumentError ->
        IO.puts("Title can not be blank.")
    end



  end

  def get_list_and_items() do
    list =
      IO.gets("Enter a list to retrieve: ")
      |> String.trim()
      |> TodoCli.get_list_by_title()
  end

  def change_list_title() do
    try do
      list =
        IO.gets("Which list would you like to change? ")
        |> String.trim()
        |> TodoCli.update_list_title(IO.gets("Enter a new title: "))
    rescue
      e in UndefinedFunctionError ->
        IO.puts("There seems to be a problem, that task doesn't exist" <> e.message)

      e in Ecto.NoResultsError ->
        IO.puts("That list doesn't exist." <> e.message)
    end
  end

  def add_item_to_list() do
    try do
      list =
        IO.gets("Enter a list to add task: ")
        |> String.trim()
        |> TodoCli.create_item(IO.gets("Enter a task: ") |> String.trim())
    rescue
      e in UndefinedFunctionError ->
        IO.puts("There seems to be a problem, that task doesn't exist" <> e.message)

      e in Ecto.NoResultsError ->
        IO.puts("That list doesn't exist." <> e.message)
    end
  end

  def mark_task_done() do
    list =
      IO.gets("Which list is your task in? ")
      |> String.trim()

    task =
      IO.gets("Which task is complete? ")
      |> String.trim()

    try do
      item = TodoCli.get_item(list, task) |> Enum.at(0)
      TodoCli.task_complete(item)
      IO.puts("Task complete.")
    rescue
      UndefinedFunctionError ->
        IO.puts("There seems to be a problem, that task doesn't exist")

      Ecto.NoResultsError ->
        IO.puts("That list doesn't exist.")
    end
  end

  def remove_task() do
    list =
      IO.gets("Which list is your task in? ")
      |> String.trim()

    task =
      IO.gets("Which task do you want to remove? ")
      |> String.trim()

    try do
      item = TodoCli.get_item(list, task) |> Enum.at(0)
      TodoCli.Repo.delete!(%TodoCli.ListItems{id: item.id})
      IO.puts("Task removed.")
    rescue
      UndefinedFunctionError ->
        IO.puts("There seems to be a problem, that task doesn't exist")

      Ecto.NoResultsError ->
        IO.puts("That list doesn't exist.")
    end
  end
end
