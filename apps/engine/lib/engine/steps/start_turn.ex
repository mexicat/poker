defmodule Engine.Steps.StartTurn do
  alias Engine.{Deck, Game}
  import Engine.GameUtils
  use Opus.Pipeline

  step :update_turn, with: &Map.put(&1, :turn, &1.turn + 1), unless: :initializing?
  step :move_positions, unless: :initializing?
  tee :reset_deck, with: &Deck.reset(&1.deck), unless: :initializing
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
    current_player = turn_start_player_id(dealer, players)
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
    sb_id = small_blind_player_id(dealer, players)
    bb_id = big_blind_player_id(dealer, players)

    sb_player =
      players
      |> Map.get(sb_id)
      |> Map.update!(:coins, &(&1 - small_blind))
      |> Map.put(:bet, small_blind)

    bb_player =
      players
      |> Map.get(bb_id)
      |> Map.update!(:coins, &(&1 - big_blind))
      |> Map.put(:bet, big_blind)

    players = players |> Map.put(sb_id, sb_player) |> Map.put(bb_id, bb_player)

    %{game | players: players, pot: game.pot + big_blind + small_blind, bet: big_blind}
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
