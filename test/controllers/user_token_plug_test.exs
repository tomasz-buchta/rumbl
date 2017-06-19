defmodule Rumbl.UserTokenPlugTest do
  use Rumbl.ConnCase
  alias Rumbl.UserTokenPlug

  test "puts the token when current user is assigned", %{conn: conn} do
    conn = 
      conn
      |> assign(:current_user, %Rumbl.User{id: 1})
      |> UserTokenPlug.call({})

    assert conn.assigns.user_token
  end

  test "does not put the token when current user not is assigned", %{conn: conn} do
    conn = 
      conn
      |> assign(:current_user, nil)
      |> UserTokenPlug.call({})

    refute conn.assigns.user_token
  end
end
