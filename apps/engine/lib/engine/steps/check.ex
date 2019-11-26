defmodule Engine.Steps.Check do
  import Engine.GameUtils
  alias Engine.{Game, Steps}
  use Opus.Pipeline

  check :player_bet_equal_to_game_bet?
  step :accept_check
  link Steps.NextStep

  @spec player_bet_equal_to_game_bet?(Game.t()) :: boolean
  def player_bet_equal_to_game_bet?(game) do
    player = current_player(game)
    game.bet == player.bet
  end

  @spec accept_check(Game.t()) :: Game.t()
  def accept_check(game = %Game{}) do
    game
    |> current_player()
    |> Map.put(:action, :check)
    |> set_player(game)
    |> log("#{current_player(game).name} checked")
  end
end
