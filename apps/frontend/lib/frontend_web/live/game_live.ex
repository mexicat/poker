defmodule FrontendWeb.GameLive do
  use Phoenix.LiveView
  import Phoenix.PubSub

  alias Phoenix.LiveView.Socket

  def render(assigns) do
    FrontendWeb.GameView.render("game.html", assigns)
  end

  def mount(%{game_name: game_name} = assigns, socket) do
    if connected?(socket) do
      :ok = subscribe(FrontendWeb.PubSub, "game/#{game_name}")
    else
      :ok = unsubscribe(FrontendWeb.PubSub, "game/#{game_name}")
    end

    {:ok, assign(socket, assigns)}
  end

  def process_action_queue(game_name) do
    game =
      game_name
      |> Engine.via_tuple()
      |> Engine.status()

    actions =
      game.log_server
      |> Engine.LogServer.process_queue()
      |> Enum.reverse()

    Enum.each(actions, fn {action, game, opts} ->
      if Keyword.get(opts, :broadcast) do
        update_clients(game_name, game)
        # if length(actions) > 1, do: :timer.sleep(1000)
        # if delay = Keyword.get(opts, :delay), do: :timer.sleep(delay)
      end
    end)
  end

  def update_clients_and_reply(socket) do
    process_action_queue(socket.assigns.game_name)
    {:noreply, socket}
  end

  def update_clients(game_name, game) do
    broadcast(
      FrontendWeb.PubSub,
      "game/#{game_name}",
      {:game_state_updated, game}
    )
  end

  def handle_info({:game_state_updated, game}, socket) do
    {:noreply, assign(socket, :game, game)}
  end

  def handle_event("start_game", _, socket) do
    game = Engine.via_tuple(socket.assigns.game_name)

    case Engine.start_game(game) do
      :ok -> update_clients_and_reply(socket)
      error -> handle_error(error, socket)
    end
  end

  def handle_event("check", _, socket) do
    game = Engine.via_tuple(socket.assigns.game_name)
    player_id = socket.assigns.player_id

    case Engine.check(game, player_id) do
      :ok -> update_clients_and_reply(socket)
      error -> handle_error(error, socket)
    end
  end

  def handle_event("bet", %{"amount" => amount}, socket) do
    game = Engine.via_tuple(socket.assigns.game_name)
    player_id = socket.assigns.player_id
    amount = String.to_integer(amount)

    case Engine.bet(game, player_id, amount) do
      :ok -> update_clients_and_reply(socket)
      error -> handle_error(error, socket)
    end
  end

  def handle_event("call_bet", _, socket) do
    game = Engine.via_tuple(socket.assigns.game_name)
    player_id = socket.assigns.player_id

    case Engine.call_bet(game, player_id) do
      :ok -> update_clients_and_reply(socket)
      error -> handle_error(error, socket)
    end
  end

  def handle_event("fold", _, socket) do
    game = Engine.via_tuple(socket.assigns.game_name)
    player_id = socket.assigns.player_id

    case Engine.fold(game, player_id) do
      :ok -> update_clients_and_reply(socket)
      error -> handle_error(error, socket)
    end
  end

  def handle_event(_, _, socket), do: {:noreply, socket}

  defp handle_error({:error, err}, socket) do
    IO.inspect(err)
    {:noreply, assign(socket, :error, Atom.to_string(err))}
  end

  defp handle_error(:error, socket), do: {:noreply, assign(socket, :error, "unknown error")}
end
