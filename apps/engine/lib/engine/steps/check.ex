defmodule Engine.Steps.Check do
  import Engine.GameUtils
  use Opus.Pipeline

  check :player_bet_equal_to_game_bet?
  step :set_action
  link Engine.Steps.NextPlayer

  def player_bet_equal_to_game_bet?(game) do
    player = current_player(game)
    game.bet == player.bet
  end

  def set_action(game = %{}) do
    game
    |> current_player()
    |> Map.put(:action, :check)
    |> set_player(game)
  end
end
