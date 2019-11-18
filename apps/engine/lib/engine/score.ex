defmodule Engine.Score do
  alias Engine.Card

  defguardp is_straight(a, b, c, d, e)
            when a - 1 == b and b - 1 == c and c - 1 == d and d - 1 == e

  def sort(cards) do
    cards
    |> Enum.sort_by(
      fn card -> {Enum.count(cards, &(card.num == &1.num)), card.num} end,
      &>=/2
    )
    |> Enum.take(5)
  end

  def sort_for_straight_flush(cards) do
    cards
    |> Enum.sort_by(
      fn card -> {Enum.count(cards, &(card.suit == &1.suit)), card.num} end,
      &>=/2
    )
    |> check_min_straight()
    |> Enum.take(5)
  end

  def sort_for_straight(cards) do
    cards
    |> Enum.uniq_by(fn %{num: n, suit: _} -> n end)
    |> Enum.sort(&>=/2)
    |> check_min_straight()
    |> Enum.take(5)
  end

  def sort_by_color(cards) do
    cards
    |> Enum.sort_by(
      fn card -> {Enum.count(cards, &(card.suit == &1.suit)), card.suit} end,
      &>=/2
    )
    |> Enum.take(5)
  end

  def check_min_straight([
        %Card{num: 14} = c1,
        %Card{num: 5} = c2,
        %Card{num: 4} = c3,
        %Card{num: 3} = c4,
        %Card{num: 2} = c5
      ]),
      do: [c2, c3, c4, c5, %{c1 | num: 1}]

  def check_min_straight(cards) do
    with ace = %Card{} <- Enum.find(cards, nil, &(&1.num == 14)),
         two = %Card{} <- Enum.find(cards, nil, &(&1.num == 2)),
         three = %Card{} <- Enum.find(cards, nil, &(&1.num == 3)),
         four = %Card{} <- Enum.find(cards, nil, &(&1.num == 4)),
         five = %Card{} <- Enum.find(cards, nil, &(&1.num == 5)) do
      [five, four, three, two, %{ace | num: 1}]
    else
      nil -> cards
    end
  end

  def score_hand(cards) do
    {score, ordered} =
      cards |> sort_for_straight_flush |> has_straight_flush? ||
        cards |> sort |> has_four_of_a_kind? ||
        cards |> sort |> has_full_house? ||
        cards |> sort_by_color |> has_flush? ||
        cards |> sort_for_straight |> has_straight? ||
        cards |> sort |> has_three_of_a_kind? ||
        cards |> sort |> has_two_pair? ||
        cards |> sort |> has_one_pair? ||
        {:high_card, cards |> sort}

    %{score: score, cards: cards, ordered: ordered}
  end

  def has_straight_flush?(
        [
          %Card{num: a, suit: s},
          %Card{num: b, suit: s},
          %Card{num: c, suit: s},
          %Card{num: d, suit: s},
          %Card{num: e, suit: s}
        ] = cards
      )
      when is_straight(a, b, c, d, e),
      do: {:straight_flush, cards}

  def has_straight_flush?(_), do: false

  def has_four_of_a_kind?(
        [
          %Card{num: a},
          %Card{num: a},
          %Card{num: a},
          %Card{num: a},
          %Card{}
        ] = cards
      ),
      do: {:four_of_a_kind, cards}

  def has_four_of_a_kind?(_), do: false

  def has_full_house?(
        [
          %Card{num: a},
          %Card{num: a},
          %Card{num: a},
          %Card{num: b},
          %Card{num: b}
        ] = cards
      ),
      do: {:full_house, cards}

  def has_full_house?(_), do: false

  def has_flush?(
        [
          %Card{suit: s},
          %Card{suit: s},
          %Card{suit: s},
          %Card{suit: s},
          %Card{suit: s}
        ] = cards
      ),
      do: {:flush, cards}

  def has_flush?(_), do: false

  def has_straight?(
        [
          %Card{num: a},
          %Card{num: b},
          %Card{num: c},
          %Card{num: d},
          %Card{num: e}
        ] = cards
      )
      when is_straight(a, b, c, d, e),
      do: {:straight, cards}

  def has_straight?(_), do: false

  def has_three_of_a_kind?(
        [
          %Card{num: a},
          %Card{num: a},
          %Card{num: a},
          %Card{},
          %Card{}
        ] = cards
      ),
      do: {:three_of_a_kind, cards}

  def has_three_of_a_kind?(_), do: false

  def has_two_pair?(
        [
          %Card{num: a},
          %Card{num: a},
          %Card{num: b},
          %Card{num: b},
          %Card{}
        ] = cards
      ),
      do: {:two_pair, cards}

  def has_two_pair?(_), do: false

  def has_one_pair?(
        [
          %Card{num: a},
          %Card{num: a},
          %Card{},
          %Card{},
          %Card{}
        ] = cards
      ),
      do: {:one_pair, cards}

  def has_one_pair?(_), do: false
end
