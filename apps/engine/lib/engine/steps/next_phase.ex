defmodule Engine.Steps.NextPhase do
  import Engine.GameUtils
  alias Engine.{Game, Steps}
  use Opus.Pipeline

  step :reset_players
  step :set_starting_player
  link Steps.Results, if: &(&1.phase == :river)
  link Steps.ToRiver, if: &(&1.phase == :turn)
  link Steps.ToTurn, if: &(&1.phase == :flop)
  link Steps.ToFlop, if: &(&1.phase == :preflop)

  def reset_players(game = %Game{players: players}) do
    players =
      players
      |> Enum.map(fn {k, player} -> {k, %{player | bet: 0, action: nil}} end)
      |> Enum.into(%{})

    %{game | players: players, bet: 0}
  end

  def set_starting_player(game = %Game{dealer: dealer, players: players}) do
    %{game | player_turn: small_blind_player(dealer, players)}
  end
end
