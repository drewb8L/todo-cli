defmodule TodoCli do
  alias TodoCli.Repo
  alias TodoCli.{List, ListItems}
  import Ecto.Query

  def add_list(title) do
    list = List.changeset(%List{}, %{title: title})

    try do
      Repo.insert!(list) |> Repo.preload(:items)
    rescue
      Ecto.InvalidChangesetError ->
        IO.puts("Error, list name can not be blank")
    end
  end

  def remove_list(title) do
    list = Repo.get_by!(List, title: title)
    Repo.delete!(list)
  end

  def update_list_title(list, new_title) do
    list = Repo.get_by!(List, title: list)

    from(l in List, where: l.id == ^list.id)
    |> Repo.update_all(set: [title: String.trim(new_title)])
  end

  def get_list_by_title(title) do
    list =
      if title != "" do
        Repo.all(from(l in List, where: l.title == ^title, preload: [:items]))
      else
        IO.puts("title is blank")
      end

    if list != [] do
      list = hd(list)

      if list.items != [] do
        Enum.map(list.items, fn i -> %{"task" => i.task, "done" => i.done} end)
        |> Tabula.print_table()
      else
        IO.puts("This list has no tasks")
      end
    else
      IO.puts("That list doesn't exist.")
    end
  end

  def create_item(list_name, task) do
    if task != "" do
      new_task = String.trim(task)
      list = Repo.get_by!(List, title: list_name)

      Ecto.build_assoc(list, :items)
      |> Ecto.Changeset.change(task: new_task, done: false)
      |> Repo.insert!()

      IO.puts("Task successfully added")
    else
      IO.puts("Task name can not be blank")
    end
  end

  def get_item(list, task) do
    my_list = Repo.get_by!(List, title: list)

    Repo.all(
      from(i in ListItems,
        where: i.list_id == ^my_list.id and i.task == ^task
      )
    )
  end

  def task_complete(task_name) do
    TodoCli.ListItems.changeset2(%ListItems{id: task_name.id}, %{done: true}) |> Repo.update()
  end

  def mark_all_task_done(title) do
    list =
      Repo.all(from(l in List, where: l.title == ^title, preload: [:items]))
      |> hd()

    Enum.each(list.items, fn i ->
      TodoCli.ListItems.changeset2(%ListItems{id: i.id}, %{done: true}) |> Repo.update!()
    end)

    list_update = Repo.all(from(l in List, where: l.title == ^title, preload: [:items])) |> hd()

    Enum.map(list_update.items, fn i -> %{"task" => i.task, "done" => i.done} end)
    |> Tabula.print_table()
  end

  def reset_list(list) do
  end
end
