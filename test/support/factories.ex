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
      url: sequence(:url, &"www.example.com/video#{&1}"),
      title: sequence(:title, &"Funny cats #{&1}"),
      description: "video with funny cats",
      # associations are inserted when you call `insert`
      user: build(:user),
    }
  end

  def category_factory do
    %Rumbl.Category{
      name: sequence(:name, &"category-#{&1}")
    }
  end
end
