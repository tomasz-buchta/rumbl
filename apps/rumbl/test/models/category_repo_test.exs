defmodule Rumbl.CategoryRepoTest do
  use Rumbl.ModelCase, async: false
  alias Rumbl.Category
  import Rumbl.Factory
  import Ecto.Query, only: [from: 2]

  test "alphabetical/1 orders by name" do
    insert(:category, name: "c")
    insert(:category, name: "a")
    insert(:category, name: "b")

    query = Category |> Category.alphabetical
    query = from c in query,
              select: c.name
    assert Repo.all(query) == ~w(a b c)
  end
end
