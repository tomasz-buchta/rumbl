defmodule Rumbl.Router do
  use Rumbl.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
    plug Rumbl.UserTokenPlug
  end

  scope "/" do
    pipe_through :browser
    coherence_routes
    get "/", Rumbl.PageController, :index
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
    resources "/videos", Rumbl.VideoController
    get "/watch/:id", Rumbl.WatchController, :show
  end

  pipeline :api do
    plug :accepts, ["json"]
  end
end
