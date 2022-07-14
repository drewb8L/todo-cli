alias TodoCli.Console

defmodule Main do
  def create_list() do
    list =
      try do
        Console.input("Create a new list: ")
      rescue
        ArgumentError ->
          Console.display("List title can not be blank")
      end

    if list != "" do
      title =
        try do
          new_list = TodoCli.add_list(list)
          _title = new_list.title
        rescue
          UndefinedFunctionError ->
            Console.display("There seems to be a problem, that task doesn't exist")

          ArgumentError ->
            Console.display("Title can not be blank.")
        end

      task = Console.input("Create an item: ") |> String.trim()

      cond do
        task == "" ->
          Console.display("Task name can not be blank.")

        task != "" ->
          TodoCli.create_item(title, task)
      end
    else
      Console.display("Blank list names are not allowed.")
    end
  end

  def delete_list do
    try do
      Console.input("Enter the list you wat to remove: ")
      |> String.trim()
      |> TodoCli.remove_list()

      Console.display("List removed.")
    rescue
      ArgumentError ->
        Console.display("Title can not be blank.")

      Ecto.NoResultsError ->
        Console.display("That list doesn't exist.")
    end
  end

  def get_list_and_items() do
    list = Console.input("Enter a list to retrieve: ") |> String.trim()

    if list != "" do
      list
      |> String.trim()
      |> TodoCli.get_list_by_title()
    else
      Console.display("Please enter a list name")
    end
  end

  def change_list_title() do
    try do
      Console.input("Which list would you like to change? ")
      |> String.trim()
      |> TodoCli.update_list_title(Console.input("Enter a new title: "))
    rescue
      UndefinedFunctionError ->
        Console.display("There seems to be a problem, that task doesn't exist")

      Ecto.NoResultsError ->
        Console.display("That list doesn't exist.")
    end
  end

  def add_item_to_list() do
    try do
        Console.input("Enter a list to add task: ")
        |> String.trim()
        |> TodoCli.create_item(Console.input("Enter a task: ") |> String.trim())
    rescue
      UndefinedFunctionError ->
        Console.display("There seems to be a problem, that task doesn't exist")

      Ecto.NoResultsError ->
        Console.display("That list doesn't exist.")
    end
  end

  def mark_task_done() do
    list =
      Console.input("Which list is your task in? ")
      |> String.trim()

    task =
      Console.input("Which task is complete? ")
      |> String.trim()

    try do
      item = TodoCli.get_item(list, task) |> Enum.at(0)
      TodoCli.task_complete(item)
      Console.display("Task complete.")
    rescue
      UndefinedFunctionError ->
        Console.display("There seems to be a problem, that task doesn't exist")

      Ecto.NoResultsError ->
        Console.display("That list doesn't exist.")
    end
  end

  def remove_task() do
    list =
      Console.input("Which list is your task in? ")
      |> String.trim()

    task =
      Console.input("Which task do you want to remove? ")
      |> String.trim()

    try do
      item = TodoCli.get_item(list, task) |> Enum.at(0)
      TodoCli.Repo.delete!(%TodoCli.ListItems{id: item.id})
      Console.display("Task removed.")
    rescue
      UndefinedFunctionError ->
        Console.display("There seems to be a problem, that task doesn't exist")

      Ecto.NoResultsError ->
        Console.display("That list doesn't exist.")
    end
  end

  def complete_all_tasks do
    list =
      Console.input("Which list are your tasks in? ")
      |> String.trim()
      |> TodoCli.mark_all_task_done()
  end
end
