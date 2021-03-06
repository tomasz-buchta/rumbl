defmodule Rumbl.VideoController do
  use Rumbl.Web, :controller

  alias Rumbl.Video
  alias Rumbl.Category

  plug :load_categories when action in [:new, :create, :edit, :update]

  def index(conn, _params, current_user) do
    videos = Repo.all(user_videos(current_user))
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, current_user) do
    changeset =
      current_user
      |> build_assoc(:videos)
      |> Video.changeset
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, current_user) do
    changeset =
      current_user
      |> build_assoc(:videos)
      |> Video.changeset(video_params)

    case Repo.insert(changeset) do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    video = Repo.get!(user_videos(current_user), id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, current_user) do
    video = Repo.get!(user_videos(current_user), id)
    changeset = Video.changeset(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, current_user) do
    video = Repo.get!(user_videos(current_user), id)
    changeset = Video.changeset(video, video_params)

    case Repo.update(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    video = Repo.get!(user_videos(current_user), id)
    Repo.delete!(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
                                  [conn, conn.params, conn.assigns.current_user])
  end

  defp load_categories(conn, _) do
    categories =
      Category
      |> Category.alphabetical
      |> Category.names_and_ids
      |> Repo.all
    assign(conn, :categories, categories)
    
  end

  defp user_videos(user) do
    assoc(user, :videos)
  end
end
