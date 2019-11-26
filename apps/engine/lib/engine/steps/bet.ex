defmodule Engine.Steps.Bet do
  import Engine.GameUtils
  alias Engine.{Game, Steps}
  use Opus.Pipeline

  check :at_least_big_blind?
  check :higher_than_current_bet?
  check :enough_coins_to_bet?
  step :accept_bet
  link Steps.NextStep

  @spec at_least_big_blind?({Game.t(), integer}) :: boolean
  def at_least_big_blind?({%Game{big_blind: big_blind}, bet}) do
    bet >= big_blind
  end

  @spec higher_than_current_bet?({Game.t(), integer}) :: boolean
  def higher_than_current_bet?({%Game{bet: current_bet}, bet}) do
    bet > current_bet
  end

  @spec enough_coins_to_bet?({Game.t(), integer}) :: boolean
  def enough_coins_to_bet?({game = %Game{}, bet}) do
    player = current_player(game)
    player.coins >= bet - player.bet
  end

  @spec accept_bet({Game.t(), integer}) :: Game.t()
  def accept_bet({game = %Game{}, bet}) do
    player = current_player(game)
    spent = bet - player.bet

    player
    |> Map.update!(:coins, &(&1 - spent))
    |> Map.put(:bet, bet)
    |> Map.put(:action, :bet)
    |> set_player(game)
    # back to the game struct here
    |> Map.put(:bet, bet)
    |> Map.update!(:pot, &(&1 + spent))
    |> log("#{player.name} bet/raised to #{bet}")
  end
end
