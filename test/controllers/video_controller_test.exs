defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase

  import Ecto.Query

  alias Rumbl.Video
  alias Rumbl.User
  @valid_attrs %{description: "some content", title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, video_path(conn, :new)),
      get(conn, video_path(conn, :index)),
      get(conn, video_path(conn, :show, "123")),
      get(conn, video_path(conn, :edit, "123")),
      put(conn, video_path(conn, :update, "123", %{})),
      post(conn, video_path(conn, :create, %{})),
      delete(conn, video_path(conn, :delete, "123")),
    ], fn conn ->
      assert html_response(conn, 200)
      assert conn.halted
    end)
  end

  describe "when user signed in" do
    setup %{conn: conn} do
      user = %User{email: "user@test.com", name: "User user"} |> Repo.insert!
      conn = conn |> assign(:current_user, user)
      %{conn: conn, user: user}
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, video_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing videos"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get conn, video_path(conn, :new)
      assert html_response(conn, 200) =~ "New video"
    end

    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post conn, video_path(conn, :create), video: @valid_attrs
      assert redirected_to(conn) == video_path(conn, :index)
      video = Video |> last |> preload(:user) |> Repo.one
      assert video
      assert video.user
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, video_path(conn, :create), video: @invalid_attrs
      assert html_response(conn, 200) =~ "New video"
    end

    test "shows chosen resource", %{conn: conn, user: user} do
      video = Repo.insert! %Video{user: user}
      conn = get conn, video_path(conn, :show, video)
      assert html_response(conn, 200) =~ "Show video"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, video_path(conn, :show, -1)
      end
    end

    test "renders form for editing chosen resource", %{conn: conn, user: user} do
      video = Repo.insert! %Video{user: user}
      conn = get conn, video_path(conn, :edit, video)
      assert html_response(conn, 200) =~ "Edit video"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
      video = Repo.insert! %Video{user: user}
      conn = put conn, video_path(conn, :update, video), video: @valid_attrs
      assert redirected_to(conn) == video_path(conn, :show, video)
      assert Repo.get_by(Video, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
      video = Repo.insert! %Video{user: user}
      conn = put conn, video_path(conn, :update, video), video: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit video"
    end

    test "deletes chosen resource", %{conn: conn, user: user} do
      video = Repo.insert! %Video{user: user}
      conn = delete conn, video_path(conn, :delete, video)
      assert redirected_to(conn) == video_path(conn, :index)
      refute Repo.get(Video, video.id)
    end
  end
end
