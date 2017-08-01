defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase

  import Ecto.Query
  import Rumbl.Factory

  alias Rumbl.Video

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
      user = insert(:user)
      conn = conn |> assign(:current_user, user)
      %{conn: conn, user: user}
    end

    test "authorizes actions against access by other users", %{user: owner, conn: conn} do
      video = insert(:video, user: owner)
      non_owner = insert(:user)
      conn = assign(conn, :current_user, non_owner)

      assert_error_sent :not_found, fn ->
        get(conn, video_path(conn, :show, video))
      end

      assert_error_sent :not_found, fn ->
        get(conn, video_path(conn, :edit, video))
      end

      assert_error_sent :not_found, fn ->
        put(conn, video_path(conn, :update, video, video: params_for(:video)))
      end

      assert_error_sent :not_found, fn ->
        delete(conn, video_path(conn, :delete, video))
      end
    end

    test "lists user entries on index", %{conn: conn, user: user} do
      insert(:video, title: "Fancy video", user: user)
      insert(:video, title: "Not fancy video")
      conn = get conn, video_path(conn, :index)
      assert html_response(conn, 200) =~ "Fancy video"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get conn, video_path(conn, :new)
      assert html_response(conn, 200) =~ "New video"
    end

    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post conn, video_path(conn, :create), video: params_with_assocs(:video)
      assert redirected_to(conn) == video_path(conn, :index)
      video = Video |> last |> preload(:user) |> Repo.one
      assert video
      assert video.user
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, video_path(conn, :create), video: %{}
      assert html_response(conn, 200) =~ "New video"
    end

    test "shows chosen resource", %{conn: conn, user: user} do
      video = insert(:video, user: user)
      conn = get conn, video_path(conn, :show, video)
      assert html_response(conn, 200) =~ "Show video"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, video_path(conn, :show, "9999-nonexistent")
      end
    end

    test "renders form for editing chosen resource", %{conn: conn, user: user} do
      video = insert(:video, user: user)
      conn = get conn, video_path(conn, :edit, video)
      assert html_response(conn, 200) =~ "Edit video"
    end

    @tag :skip
    test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
      video = params_with_assocs(:video, user: user)
      video = Video.changeset(%Video{}, video) |> Repo.insert!
      conn = put conn, video_path(conn, :update, video),
        video: video
      assert redirected_to(conn) == video_path(conn, :show, video)
      assert Repo.get_by(Video, id: video.id)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
      video = insert(:video, user: user, url: "")
      conn = put conn, video_path(conn, :update, video), video: %{}
      assert html_response(conn, 200) =~ "Edit video"
    end

    test "deletes chosen resource", %{conn: conn, user: user} do
      video = insert(:video, user: user)
      conn = delete conn, video_path(conn, :delete, video)
      assert redirected_to(conn) == video_path(conn, :index)
      refute Repo.get(Video, video.id)
    end
  end
end
