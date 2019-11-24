defmodule Engine.Steps.ToFlop do
  alias Engine.{Deck, Game}
  import Engine.GameUtils
  use Opus.Pipeline

  step :add_cards_to_board
  step :next, with: &Map.put(&1, :phase, :flop)

  def add_cards_to_board(game = %Game{deck: deck}) do
    %{game | board: Deck.draw_cards(deck, 3)}
    |> log("Three cards for the flop")
  end
end
