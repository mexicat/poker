defmodule Engine.Steps.Check do
  import Engine.GameUtils
  alias Engine.Steps
  use Opus.Pipeline

  check :player_bet_equal_to_game_bet?
  step :accept_check
  link Steps.NextStep

  def player_bet_equal_to_game_bet?(game) do
    player = current_player(game)
    game.bet == player.bet
  end

  def accept_check(game = %{}) do
    game
    |> current_player()
    |> Map.put(:action, :check)
    |> set_player(game)
    |> log("#{current_player(game).name} checked")
  end
end
