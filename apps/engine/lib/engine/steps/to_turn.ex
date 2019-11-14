defmodule Engine.Steps.ToTurn do
  alias Engine.{Deck, Game}
  use Opus.Pipeline

  step :add_cards_to_board
  step :next, with: &Map.put(&1, :phase, :turn)

  def add_cards_to_board(game = %Game{deck: deck, board: board}) do
    %{game | board: board ++ Deck.draw_cards(deck, 1)}
  end
end
