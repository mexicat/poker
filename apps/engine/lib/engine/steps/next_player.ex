defmodule Engine.Steps.NextStep do
  import Engine.GameUtils
  alias Engine.Game
  use Opus.Pipeline

  # link Results, if: :turn_complete?
  step :set_next_player, unless: &(!turn_complete?(&1) && phase_complete?(&1))
  link Engine.Steps.NextPhase, if: &(!turn_complete?(&1) && phase_complete?(&1))
  link Engine.Steps.Results, if: &turn_complete?(&1)
  step :cleanup, if: &(&1.phase == :finished)

  def set_next_player(game = %Game{player_turn: player, players: players}) do
    %{game | player_turn: next_player(player, players)}
  end
end
