defmodule Engine.Card do
  alias __MODULE__

  @type t :: %Card{num: 1..13, suit: :hearts | :diamonds | :clubs | :spades}
  @enforce_keys [:num, :suit]
  defstruct [:num, :suit]
end
