defmodule Engine.Steps.CallBet do
  import Engine.GameUtils
  alias Engine.Game
  use Opus.Pipeline

  check :enough_coins_to_call?
  step :accept_call
  link Engine.Steps.NextPlayer

  def enough_coins_to_call?(game = %Game{}) do
    player = current_player(game)
    player.coins >= game.bet - player.bet
  end

  def accept_call(game = %Game{}) do
    player = current_player(game)
    spent = game.bet - player.bet

    player
    |> Map.update!(:coins, &(&1 - spent))
    |> Map.put(:bet, game.bet)
    |> Map.put(:action, :call_bet)
    |> set_player(game)
    # back to the game struct here
    |> Map.update!(:pot, &(&1 + spent))
  end
end
