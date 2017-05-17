defmodule Rumbl.VideoViewTest do
  use Rumbl.ConnCase, async: true
  import Rumbl.Factory
  import Phoenix.View

  test "render index.html", %{conn: conn} do
    videos = insert_pair(:video)

    content = render_to_string(Rumbl.VideoView, "index.html", conn: conn, videos: videos)

    assert String.contains?(content, "Listing videos")

    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end
end
