defmodule TodoCli do
  alias TodoCli.Repo
  alias TodoCli.{List, ListItems}
  import Ecto.Query

  def add_list(title) do
    list = List.changeset(%List{}, %{title: title})
    IO.puts("Your list '#{title}' has been created!")
    Repo.insert!(list)
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
    Repo.all(from(l in List, where: l.title == ^title, preload: [:items]))
  end

  def create_item(list_name, task) do
    new_task = String.trim(task)
    list = Repo.get_by!(List, title: list_name)

    Ecto.build_assoc(list, :items)
    |> Ecto.Changeset.change(task: new_task, done: false)
    |> Repo.insert!()

    IO.puts("Item successfully added")
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
end
