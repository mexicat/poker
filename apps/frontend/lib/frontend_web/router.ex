defmodule FrontendWeb.Router do
  use FrontendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FrontendWeb do
    pipe_through :browser

    get "/", GameController, :index
    post "/new", GameController, :new_game
    post "/join", GameController, :join_game
    get "/game", GameController, :game
  end

  # Other scopes may use custom stacks.
  # scope "/api", FrontendWeb do
  #   pipe_through :api
  # end
end
