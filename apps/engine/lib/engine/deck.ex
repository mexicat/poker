defmodule Engine.Deck do
  alias Engine.Card

  @type t :: [Card.t(), ...]

  def new() do
    generate_cards() |> Enum.shuffle()
  end

  def draw_cards(deck, n) when n > length(deck), do: {:error, :deck_too_thin}

  def draw_cards(deck, n) do
    Enum.split(deck, n)
  end

  defp generate_cards() do
    for suit <- [:hearts, :diamonds, :clubs, :spades], num <- 1..13 do
      %Card{suit: suit, num: num}
    end
  end
end
