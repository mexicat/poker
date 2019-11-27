defmodule Engine.Steps.ToTurn do
  alias Engine.{Deck, Game}
  import Engine.GameUtils
  use Opus.Pipeline

  step :add_cards_to_board
  step :next, with: &Map.put(&1, :phase, :turn)
  step :set_starting_player, with: &set_starting_player/1

  @spec add_cards_to_board(Game.t()) :: Game.t()
  def add_cards_to_board(game = %Game{deck: deck, board: board}) do
    {turn, deck} = Deck.draw_cards(deck, 1)

    %{game | deck: deck, board: board ++ turn}
    |> log("One more card for the turn", broadcast: true, delay: 3000)
  end
end
