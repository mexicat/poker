defmodule ScoreTest do
  alias Engine.{Score, Card}
  use ExUnit.Case
  doctest Engine.Score

  test "straight flush" do
    assert %{score: :straight_flush} =
             Card.from_string(~w/AS 3S 2S 4S JD KD 5S/) |> Score.score_hand(0)

    assert %{score: :straight_flush} =
             Card.from_string(~w/AS 3S 2S 4S 6S KD 5S/) |> Score.score_hand(0)

    assert %{score: :straight_flush} =
             Card.from_string(~w/AS KS 10S 4S JS QS 5D/) |> Score.score_hand(0)

    assert %{score: :straight_flush} =
             Card.from_string(~w/9S 8S 10S 5S JS QS 5D/) |> Score.score_hand(0)
  end

  test "four of a kind" do
    assert %{score: :four_of_a_kind} =
             Card.from_string(~w/AS 9S 5D AD AH AC 4C/) |> Score.score_hand(0)

    assert %{score: :four_of_a_kind} =
             Card.from_string(~w/9C 9S 5D AD 9H AC 9D/) |> Score.score_hand(0)
  end

  test "full house" do
    assert %{score: :full_house} =
             Card.from_string(~w/4S 9S 9D AD AH 4C AC/) |> Score.score_hand(0)

    assert %{score: :full_house} =
             Card.from_string(~w/4S 9S 9D 4D 3H 4C 7C/) |> Score.score_hand(0)
  end

  test "flush" do
    assert %{score: :flush} = Card.from_string(~w/4S 9S 3S 5S AH 4C 10S/) |> Score.score_hand(0)

    assert %{score: :flush} = Card.from_string(~w/4D 9D 8D JD 3H KD 7C/) |> Score.score_hand(0)
  end

  test "straight" do
    assert %{score: :straight} = Card.from_string(~w/AS 3D 2S 4S JD KD 5C/) |> Score.score_hand(0)

    assert %{score: :straight} = Card.from_string(~w/AD 3C 2S 4D 6S KD 5S/) |> Score.score_hand(0)

    assert %{score: :straight} =
             Card.from_string(~w/AC KS 10H 4S JC QS 5D/) |> Score.score_hand(0)

    assert %{score: :straight} =
             Card.from_string(~w/9D 8C 10H 5S JH QS 5D/) |> Score.score_hand(0)
  end

  test "three of a kind" do
    assert %{score: :three_of_a_kind} =
             Card.from_string(~w/AS AD 2S 4S AH KD 5C/) |> Score.score_hand(0)

    assert %{score: :three_of_a_kind} =
             Card.from_string(~w/2S AD 5S 6S 3S 3D 3C/) |> Score.score_hand(0)
  end

  test "two pair" do
    assert %{score: :two_pair} = Card.from_string(~w/AS AD 2S 4S 2H KD 5C/) |> Score.score_hand(0)

    assert %{score: :two_pair} = Card.from_string(~w/2S AD 5S 6S 6S 3D 3C/) |> Score.score_hand(0)
  end

  test "one pair" do
    assert %{score: :one_pair} = Card.from_string(~w/AS AD 2S 4S 9H KD 5C/) |> Score.score_hand(0)

    assert %{score: :one_pair} =
             Card.from_string(~w/2S 10D KS 6S AS 6D 3C/) |> Score.score_hand(0)
  end

  test "high card" do
    assert %{score: :high_card} =
             Card.from_string(~w/AS 8D 2S 4S 9H KD 5C/) |> Score.score_hand(0)

    assert %{score: :high_card} =
             Card.from_string(~w/2S 10D KS 6S AS 9D 3C/) |> Score.score_hand(0)
  end

  test "best hand wins" do
    players = %{
      0 => %{hand: Card.from_string(~w/4S 4C/)},
      1 => %{hand: Card.from_string(~w/3S 3C/)},
      2 => %{hand: Card.from_string(~w/5S 6C/)}
    }

    board = Card.from_string(~w/4H AD AH 7D/)

    assert [%Score{player: 0}] = Score.winning_hands(players, board)
  end

  test "multiple winners" do
    players = %{
      0 => %{hand: Card.from_string(~w/4S 4C/)},
      1 => %{hand: Card.from_string(~w/3S 3C/)}
    }

    board = Card.from_string(~w/9S 9D AD AH AC/)

    assert [
             %Score{player: 0, score: :full_house},
             %Score{player: 1, score: :full_house}
           ] = Score.winning_hands(players, board)
  end
end
