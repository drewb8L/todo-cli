defmodule TodoCli do
  alias TodoCli.Repo
  alias TodoCli.{List, ListItems}
  import Ecto.Query

  def add_list(title) do
    list = List.changeset(%List{}, %{title: title})

    cond do
      list.valid? ->
        Repo.insert!(list)
        "Your list '#{title}' has been created!"

      list.valid? == false ->
        list.errors
    end
  end

  def remove_list(title) do
    list = Repo.get_by!(List, title: title)

    if Repo.delete!(list) do
      "Deleted successfully"
    else
      "That list doesn't exist"
    end
  end

  def update_list_title(title, new_title) do
    list = Repo.get_by!(List, title: title)

    from(l in List, where: l.id == ^list.id)
    |> Repo.update_all(set: [title: new_title])
  end

  def get_list_by_title(title) do
    Repo.all(from(l in List, where: l.title == ^title, preload: [:items]))
  end

  def create_item(task, list_name) do
    list = Repo.get_by!(List, title: list_name)

    Ecto.build_assoc(list, :items)
    |> Ecto.Changeset.change(task: task, done: false)
    |> Repo.insert!()
  end
end
