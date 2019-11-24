defmodule Engine.Steps.Fold do
  import Engine.GameUtils
  alias Engine.Steps
  use Opus.Pipeline

  step :accept_fold
  link Steps.NextStep

  def accept_fold(game = %{}) do
    game
    |> current_player()
    |> Map.put(:action, :fold)
    |> Map.put(:active, false)
    |> set_player(game)
    |> log("#{current_player(game).name} folded")
  end
end
