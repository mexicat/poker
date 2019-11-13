defmodule Engine.Steps.Check do
  import Engine.GameUtils
  use Opus.Pipeline

  step :set_action
  step :set_next_player

  def set_action(game = %{}) do
    game
    |> current_player()
    |> Map.put(:action, :check)
    |> set_player(game)
  end

  def set_next_player(game = %{player_turn: player, players: players}) do
    %{game | player_turn: next_player(player, players)}
  end

  defp set_player(player, game = %{players: players}) do
    players = Map.put(players, game.player_turn, player)
    %{game | players: players}
  end

  defp current_player(%{player_turn: player, players: players}) do
    Map.get(players, player)
  end
end
