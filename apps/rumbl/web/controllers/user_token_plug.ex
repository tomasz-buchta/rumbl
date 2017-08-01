defmodule Rumbl.UserTokenPlug do
  import Plug.Conn

  def init(_opts) do
  end

  def call(conn, _params) do
    case conn.assigns.current_user do
      nil ->
        assign(conn, :user_token, nil)
      user ->
        assign(conn, :user_token, Phoenix.Token.sign(Rumbl.Endpoint, "user socket", user.id))
    end
  end
end
