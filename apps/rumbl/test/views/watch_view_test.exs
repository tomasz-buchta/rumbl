
defmodule Rumbl.WatchViewTest do
  use Rumbl.ConnCase, async: true
  import Rumbl.Factory
  import Phoenix.View

  test "render index.html", %{conn: conn} do
    video = insert(:video)

    content = render_to_string(Rumbl.WatchView, "show.html", conn: conn, video: video)

    assert String.contains?(content, "Annotations")

    assert String.contains?(content, video.title)
  end
end
