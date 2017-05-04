defmodule Rumbl.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Rumbl.Repo

  def user_factory do
    %Rumbl.User{
      name: "Jane Smith",
      email: sequence(:email, &"email-#{&1}@example.com"),
    }
  end

  def video_factory do
    %Rumbl.Video{
      url: "www.example.com",
      title: "Funny cats",
      description: "video with funny cats",
      # associations are inserted when you call `insert`
      user: build(:user),
    }
  end
end
