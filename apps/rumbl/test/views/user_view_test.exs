defmodule Rumbl.UserViewTest do
  use Rumbl.ConnCase, async: true
  import Rumbl.Factory
  alias Rumbl.UserView

  test "render user.json" do
    user = insert(:user)
    rendered_json = UserView.render("user.json", %{user: user})

    assert rendered_json == %{
      id: user.id,
      name: user.name
    }
  end

  test "extracts first name from name" do
    user = build(:user, name: "John Doe")
    assert "John" == UserView.first_name(user)
  end
end
