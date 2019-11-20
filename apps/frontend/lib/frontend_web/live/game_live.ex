defmodule FrontendWeb.GameLive do
  use Phoenix.LiveView
  import Phoenix.PubSub

  alias Phoenix.LiveView.Socket
  alias OnePoker.{Card, Game}

  def render(assigns) do
    FrontendWeb.GameView.render("game.html", assigns)
  end

  def mount(%{game_name: game_name} = assigns, socket) do
    # if connected?(socket) do
    #   :ok = subscribe(FrontendWeb.PubSub, "game/#{game_name}")
    # else
    #   :ok = unsubscribe(FrontendWeb.PubSub, "game/#{game_name}")
    # end

    {:ok, assign(socket, assigns)}
  end

  def handle_info({:game_state_updated, game_state}, socket) do
    {:noreply, assign(socket, :game_state, game_state)}
  end

  # def handle_event("draw_cards", _, %{assigns: assigns} = socket) do
  #   case assigns.game_name |> Game.via_tuple() |> Game.draw_cards() do
  #     :ok -> {:noreply, socket}
  #     error -> handle_error(error, socket)
  #   end
  # end

  # def handle_event("play_card", card_index, %{assigns: assigns} = socket) do
  #   card =
  #     Enum.at(Game.player_hand(assigns.game_state, assigns.player), String.to_integer(card_index))

  #   case assigns.game_name |> Game.via_tuple() |> Game.play_card(assigns.player, card) do
  #     :ok -> {:noreply, socket}
  #     error -> handle_error(error, socket)
  #   end
  # end

  # def handle_event("bet", %{"lives" => lives}, %{assigns: assigns} = socket) do
  #   lives = String.to_integer(lives)

  #   case assigns.game_name |> Game.via_tuple() |> Game.bet(assigns.player, lives) do
  #     :ok -> {:noreply, socket}
  #     error -> handle_error(error, socket)
  #   end
  # end

  # def handle_event("call_bet", _, %{assigns: assigns} = socket) do
  #   assigns.game_name |> Game.via_tuple() |> Game.call_bet(assigns.player)
  #   {:noreply, socket}
  # end

  # def handle_event("fold", _, %{assigns: assigns} = socket) do
  #   assigns.game_name |> Game.via_tuple() |> Game.fold(assigns.player)
  #   {:noreply, socket}
  # end

  # def handle_event("determine_winner", _, %{assigns: assigns} = socket) do
  #   assigns.game_name |> Game.via_tuple() |> Game.determine_winner()
  #   {:noreply, socket}
  # end

  def handle_event(_, _, socket), do: {:noreply, socket}

  defp handle_error({:error, err}, socket),
    do: {:noreply, assign(socket, :error, Atom.to_string(err))}

  defp handle_error(:error, socket), do: {:noreply, assign(socket, :error, "unknown error")}
end
