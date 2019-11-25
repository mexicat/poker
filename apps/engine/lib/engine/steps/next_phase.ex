defmodule Engine.Steps.NextPhase do
  import Engine.GameUtils
  alias Engine.Steps
  use Opus.Pipeline

  step :reset_players, with: &reset_players/1
  link Steps.Results, if: &(&1.phase == :river)
  link Steps.ToRiver, if: &(&1.phase == :turn)
  link Steps.ToTurn, if: &(&1.phase == :flop)
  link Steps.ToFlop, if: &(&1.phase == :preflop)
end
