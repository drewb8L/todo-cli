defmodule Main do
  import TodoCli.{List, ListItems}
  alias TodoCli.{List, ListItems}

  def create_list() do
    list = IO.gets("Create a new list: ")
    |> String.trim

    new_list = TodoCli.add_list(list)
    title = new_list.changes[:title]

    TodoCli.create_item(title, IO.gets("Create an item"))

  end

  def get_list_and_items() do
    list = IO.gets("Enter a list to retrieve: ")
           |> String.trim
           |> TodoCli.get_list_by_title()
  end

  def change_list_title() do
    list = IO.gets("Which list would you like to change? ")
    |> String.trim
    |> TodoCli.update_list_title(IO.gets("Enter a new title: "))
  end


end