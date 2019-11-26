defmodule Engine.Steps.Fold do
  import Engine.GameUtils
  alias Engine.{Game, Steps}
  use Opus.Pipeline

  step :accept_fold
  link Steps.NextStep

  @spec accept_fold(Game.t()) :: Game.t()
  def accept_fold(game = %Game{}) do
    game
    |> current_player()
    |> Map.put(:action, :fold)
    |> Map.put(:active, false)
    |> set_player(game)
    |> log("#{current_player(game).name} folded")
  end
end
