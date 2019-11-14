defmodule Engine.Steps.Fold do
  import Engine.GameUtils
  use Opus.Pipeline

  step :set_action
  link Engine.Steps.NextPlayer

  def set_action(game = %{}) do
    game
    |> current_player()
    |> Map.put(:action, :fold)
    |> Map.put(:active, false)
    |> set_player(game)
  end
end
