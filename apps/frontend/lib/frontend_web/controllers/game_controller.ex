defmodule FrontendWeb.GameController do
  use FrontendWeb, :controller
  alias Phoenix.LiveView.Controller
  import Phoenix.PubSub
  alias Frontend.GameForm

  def index(conn, _params) do
    changeset = GameForm.changeset(%GameForm{}, %{})
    render(conn, "index.html", changeset: changeset)
  end

  def new_game(conn, %{"game_form" => game_params}) do
    case GameForm.new_game(%GameForm{}, game_params) do
      {:ok, game_form} ->
        game =
          {:via, _, {_, game_name}} =
          Engine.new_game(
            small_blind: game_form.small_blind,
            player_coins: game_form.player_coins
          )

        {:ok, log_server} = Engine.LogServer.start_link()

        :ok = Engine.add_logger(game, log_server)
        {:ok, player_id} = Engine.add_player(game, game_form.player_name)

        conn
        |> put_session(:game_name, game_name)
        |> put_session(:player_id, player_id)
        |> redirect(to: "/game")

      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  def join_game(conn, %{"game_name" => game_name, "player_name" => player_name}) do
    game = Engine.via_tuple(game_name)
    {:ok, player_id} = Engine.add_player(game, player_name)

    FrontendWeb.GameLive.process_action_queue(game_name)

    conn
    |> put_session(:game_name, game_name)
    |> put_session(:player_id, player_id)
    |> redirect(to: "/game")
  end

  def game(conn, _) do
    case get_session(conn) do
      %{"game_name" => _, "player_id" => _} = session -> render_game(conn, session)
      _ -> send_resp(conn, :not_found, "Game not found")
    end
  end

  defp render_game(conn, %{"game_name" => game_name, "player_id" => player_id}) do
    game = Engine.via_tuple(game_name)

    Controller.live_render(conn, FrontendWeb.GameLive,
      session: %{
        game_name: game_name,
        error: nil,
        player_id: player_id,
        game: Engine.status(game)
      }
    )
  end
end
