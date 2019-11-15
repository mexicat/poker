defmodule Engine.Steps.NextPhase do
  import Engine.GameUtils
  alias Engine.{Game, Steps}
  use Opus.Pipeline

  step :reset_players, with: &reset_players/1
  step :set_starting_player
  link Steps.Results, if: &(&1.phase == :river)
  link Steps.ToRiver, if: &(&1.phase == :turn)
  link Steps.ToTurn, if: &(&1.phase == :flop)
  link Steps.ToFlop, if: &(&1.phase == :preflop)

  def set_starting_player(game = %Game{dealer: dealer, players: players}) do
    %{game | player_turn: small_blind_player_id(dealer, players)}
  end
end
