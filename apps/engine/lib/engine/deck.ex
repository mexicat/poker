defmodule Engine.Deck do
  alias Engine.Card

  @type t :: [Card.t(), ...]

  def start_link() do
    {:ok, pid} = Agent.start_link(&new/0)
    pid
  end

  def draw_cards(agent, n) do
    Agent.get_and_update(agent, &do_draw_cards(&1, n))
  end

  defp new() do
    generate_cards() |> Enum.shuffle()
  end

  defp do_draw_cards(deck, n) when n > length(deck), do: {:error, :deck_too_thin}

  defp do_draw_cards(deck, n) do
    Enum.split(deck, n)
  end

  defp generate_cards() do
    for suit <- [:hearts, :diamonds, :clubs, :spades], num <- 1..13 do
      %Card{suit: suit, num: num}
    end
  end
end
