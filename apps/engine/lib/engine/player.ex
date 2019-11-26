defmodule Engine.Player do
  @type t :: %Engine.Player{
          name: String.t(),
          hand: [Engine.Card.t(), ...],
          active: boolean,
          action: nil | :check | :fold | :call_bet | :bet,
          coins: integer,
          bet: integer
        }
  defstruct name: nil, hand: [], active: true, action: nil, coins: 100, bet: 0
end
