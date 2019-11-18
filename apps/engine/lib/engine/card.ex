defmodule Engine.Card do
  alias __MODULE__

  @type t :: %Card{num: 1..13, suit: :hearts | :diamonds | :clubs | :spades}
  @enforce_keys [:num, :suit]
  defstruct [:num, :suit]

  def from_string(cards) when is_list(cards) do
    for str <- cards, do: from_string(str)
  end

  def from_string(str) when is_binary(str) do
    {num, suit} = String.split_at(str, -1)

    num =
      case num do
        "A" -> 14
        "J" -> 11
        "Q" -> 12
        "K" -> 13
        x -> String.to_integer(x)
      end

    suit =
      case suit do
        "H" -> :hearts
        "D" -> :diamonds
        "C" -> :clubs
        "S" -> :spades
      end

    %Card{num: num, suit: suit}
  end
end
