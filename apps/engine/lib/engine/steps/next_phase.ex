defmodule Engine.Steps.NextPhase do
  import Engine.GameUtils
  alias Engine.Game
  use Opus.Pipeline

  step :reset_bets
  step :set_starting_player
  # link Steps.ToRiver, if: &(&1.phase == :turn)
  # link Steps.ToTurn, if: &(&1.phase == :flop)
  link Engine.Steps.ToFlop, if: &(&1.phase == :preflop)

  def reset_bets(game = %Game{players: players}) do
    players =
      players
      |> Enum.map(fn {k, player} -> {k, Map.put(player, :bet, 0)} end)
      |> Enum.into(%{})

    %{game | players: players, bet: 0}
  end

  def set_starting_player(game = %Game{dealer: dealer, players: players}) do
    %{game | player_turn: small_blind_player(dealer, players)}
  end
end
