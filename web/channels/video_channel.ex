defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel

  def join("videos:" <> video_id, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("new_annotation", params, socket) do
    broadcast! socket, "new_annotation", %{
      user: %{username: "anon"},
      body: params["body"],
      at: params["at"]
    }

    {:reply, :ok, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
