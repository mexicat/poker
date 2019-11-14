defmodule Engine.Steps.Results do
  alias Engine.Game
  use Opus.Pipeline

  step :results

  def results(game = %Game{}) do
    %{game | phase: :finished}
  end
end
