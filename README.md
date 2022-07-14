# TodoCli

**A simple cli todo list application**

## Installation

Clone the [Repo](https://github.com/drewb8L/todo-cli.git), cd into directory and run `mix deps.get`.
Next run `min ecto.setup` to set up the database.

##Functions

Run `iex -S mix` to access the functions in the Main module:

*Create a new list and add one task*

`Main.create_list`

*Add a task to an existing list*

`Main.add_item_to_list`

*Display a list and all tasks*

`Main.get_list_and_items`

*Rename an existing list*

`Main.change_list_title`

*Mark one task as done*

`Main.mark_task_done`

*Mark all task as done in a list*

`Main.complete_all_tasks`

*Delete a task from a list*

`Main.remove_task`

*Remove a list and all its tasks*

`Main.remove_list`




