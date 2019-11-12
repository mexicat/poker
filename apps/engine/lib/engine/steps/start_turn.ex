defmodule Engine.Steps.StartTurn do
  alias Engine.Deck
  use Opus.Pipeline

  step(:move_positions)
  # step :set_blinds
  step(:give_cards)

  def move_positions(game = %{players: players}) do
    players =
      Enum.map(players, fn player ->
        Map.update!(player, :position, &(&1 + 1))
      end)

    %{game | players: players}
  end

  def give_cards(game = %{players: players, deck: deck}) do
    players =
      Enum.map(players, fn player ->
        add_to_hand(player, Deck.draw_cards(deck, 2))
      end)

    %{game | players: players}
  end

  def add_to_hand(player, cards) do
    Map.put(player, :hand, cards)
  end
end
