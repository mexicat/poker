defmodule Engine.Steps.NextPlayer do
  import Engine.GameUtils
  alias Engine.Game
  use Opus.Pipeline

  # link Results, if: :turn_complete?
  step :set_next_player, unless: :phase_complete?
  link Engine.Steps.NextPhase, if: :phase_complete?

  # def turn_complete?(%Game{players: players, bet: bet}) do
  #   players
  #   |> Map.values()
  #   |> Enum.filter(& &1.active)
  #   |> length() == 1
  # end

  def phase_complete?(%Game{players: players, bet: bet}) do
    players
    |> Map.values()
    |> Enum.filter(& &1.active)
    |> Enum.filter(&(&1.bet != bet))
    |> Enum.empty?()
  end

  def set_next_player(game = %{player_turn: player, players: players}) do
    %{game | player_turn: next_player(player, players)}
  end
end
