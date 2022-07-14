defmodule TodoCli.Console do
  def display(args) do
    IO.puts(args)
  end

  def input(args \\ "") do
    IO.gets(args)
    |> String.trim()
  end
end
