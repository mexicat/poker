defmodule Engine.Steps.Results do
  alias Engine.{Game, Score}
  use Opus.Pipeline

  step :determine_winners
  step :next, with: &Map.put(&1, :phase, :finished)

  def determine_winners(game = %Game{}) do
    winning_hands = Score.winning_hands(game.players, game.board)
    winners = for h <- winning_hands, do: h.player
    %{game | winners: winners}
  end
end
