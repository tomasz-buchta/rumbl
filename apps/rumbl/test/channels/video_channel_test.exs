defmodule Rumbl.VideoChannelTest do
  use Rumbl.ChannelCase

  alias Rumbl.VideoChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(VideoChannel, "videos:1")

    {:ok, socket: socket}
  end
end
