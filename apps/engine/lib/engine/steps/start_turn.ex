defmodule Engine.Steps.StartTurn do
  alias Engine.{Deck, Game}
  import Engine.GameUtils
  use Opus.Pipeline

  step :update_turn, with: &Map.put(&1, :turn, &1.turn + 1), unless: :initializing?
  step :move_positions, unless: :initializing?
  step :set_current_player
  step :set_blinds
  step :give_cards
  step :next, with: &Map.put(&1, :phase, :preflop)

  def initializing?(%Game{phase: :initializing}), do: true
  def initializing?(%Game{}), do: false

  def move_positions(game = %Game{players: players, dealer: dealer}) do
    dealer = next_player(dealer, players)
    %{game | dealer: dealer}
  end

  def set_current_player(game = %Game{players: players, dealer: dealer}) do
    current_player = turn_start_player(dealer, players)
    %{game | player_turn: current_player}
  end

  def set_blinds(
        game = %Game{
          players: players,
          small_blind: small_blind,
          big_blind: big_blind,
          dealer: dealer
        }
      ) do
    players =
      players
      |> update_in(
        [small_blind_player(dealer, players), Access.key(:coins)],
        &(&1 - small_blind)
      )
      |> put_in(
        [small_blind_player(dealer, players), Access.key(:bet)],
        small_blind
      )
      |> update_in(
        [big_blind_player(dealer, players), Access.key(:coins)],
        &(&1 - big_blind)
      )
      |> put_in(
        [big_blind_player(dealer, players), Access.key(:bet)],
        big_blind
      )

    %{game | players: players, pot: big_blind + small_blind}
  end

  def give_cards(game = %Game{players: players, deck: deck}) do
    players =
      players
      |> Enum.map(fn {id, player} ->
        {id, Map.put(player, :hand, Deck.draw_cards(deck, 2))}
      end)
      |> Enum.into(%{})

    %{game | players: players}
  end
end
