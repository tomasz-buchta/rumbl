defmodule Rumbl.CategoryTest do
  use Rumbl.ModelCase

  alias Rumbl.Category

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "return {name, id} tuple" do
    Repo.insert!(%Category{name: "Action"})
    [{name, id}] = Category |> Category.names_and_ids |> Repo.all
    assert name == "Action"
    assert id
  end

  test "return sorted alphabetically" do
    Repo.insert!(%Category{name: "Drama"})
    Repo.insert!(%Category{name: "Action"})
    [category1, category2] = Category |> Category.alphabetical |> Repo.all
    assert category1.name == "Action"
    assert category2.name == "Drama"
  end
end
