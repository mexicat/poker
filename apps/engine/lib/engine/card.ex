defmodule Engine.Card do
  alias __MODULE__

  @type t :: %Card{num: 1..14, suit: :hearts | :diamonds | :clubs | :spades}
  @enforce_keys [:num, :suit]
  defstruct [:num, :suit]

  @num_to_string %{1 => "A", 11 => "J", 12 => "Q", 13 => "K", 14 => "A"}
  @string_to_num %{"J" => 11, "Q" => 12, "K" => 13, "A" => 14}
  @suit_to_string %{hearts: "♥️", diamonds: "♦️", clubs: "♣️", spades: "♠️"}
  @string_to_suit %{"H" => :hearts, "D" => :diamonds, "C" => :clubs, "S" => :spades}

  @doc """
  Given a string or a list of strings, returns the corresponding Card struct.

  ## Examples

      iex> Engine.Card.from_string("JS")
      %Engine.Card{num: 11, suit: :spades}
      iex> Engine.Card.from_string("10C")
      %Engine.Card{num: 10, suit: :clubs}
      iex> Engine.Card.from_string(["AD", "2H"])
      [%Engine.Card{num: 14, suit: :diamonds}, %Engine.Card{num: 2, suit: :hearts}]
  """
  @spec from_string(String.t() | [String.t(), ...]) :: Card.t() | [Card.t(), ...]
  def from_string(cards) when is_list(cards) do
    for str <- cards, do: from_string(str)
  end

  def from_string(str) when is_binary(str) do
    {num, suit} = String.split_at(str, -1)

    # Need to use `get_lazy` and supply a function, otherwise it always
    # calculates the default value - even if the key is present in @string_to_num.
    num = Map.get_lazy(@string_to_num, num, fn -> String.to_integer(num) end)
    suit = Map.get(@string_to_suit, suit)

    %Card{num: num, suit: suit}
  end

  @doc """
  Given a Card struct, returns its fancy string representation.

  ## Examples

      iex> Engine.Card.to_repr(%Engine.Card{num: 10, suit: :clubs})
      "10♣️"
      iex> Engine.Card.to_repr(%Engine.Card{num: 1, suit: :hearts})
      "A♥️"
      iex> Engine.Card.to_repr(%Engine.Card{num: 14, suit: :diamonds})
      "A♦️"
  """
  @spec to_repr(Card.t()) :: String.t()
  def to_repr(%Card{num: num, suit: suit}) do
    num = Map.get(@num_to_string, num, num)
    suit = Map.get(@suit_to_string, suit)

    "#{num}#{suit}"
  end
end
