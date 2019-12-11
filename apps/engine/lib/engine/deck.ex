defmodule Engine.Deck do
  alias Engine.{Card, Deck}

  @type t :: [Card.t(), ...]

  @spec new :: Deck.t()
  def new() do
    generate_cards() |> Enum.shuffle()
  end

  @spec draw_cards(Deck.t(), non_neg_integer()) :: {Deck.t(), Deck.t()}

  def draw_cards(deck, n) when n > length(deck),
    do: raise(ArgumentError, "not enough cards in deck")

  def draw_cards(deck, n) do
    Enum.split(deck, n)
  end

  defp generate_cards() do
    for suit <- [:hearts, :diamonds, :clubs, :spades], num <- 2..14 do
      %Card{suit: suit, num: num}
    end
  end
end
