defmodule Engine.Steps.StartTurn do
  alias Engine.{Deck, Game}
  import Engine.GameUtils
  use Opus.Pipeline

  step :update_turn, with: &Map.put(&1, :turn, &1.turn + 1), unless: :initializing?
  step :move_positions, unless: :initializing?
  step :reset_deck, with: &Map.put(&1, :deck, Deck.new()), unless: :initializing
  step :set_blinds
  step :give_cards
  step :next, with: &Map.put(&1, :phase, :preflop)
  step :set_current_player

  @spec initializing?(Game.t()) :: boolean
  def initializing?(%Game{phase: :initializing}), do: true
  def initializing?(%Game{}), do: false

  @spec move_positions(Game.t()) :: Game.t()
  def move_positions(game = %Game{players: players, dealer: dealer}) do
    dealer = next_player(dealer, players)

    %{game | dealer: dealer}
    |> log("Moved the dealer")
  end

  @spec set_blinds(Game.t()) :: Game.t()
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
    |> log(
      "#{bb_player.name} paid the big blind (#{big_blind}), #{sb_player.name} paid the small blind (#{
        small_blind
      })"
    )
  end

  @spec give_cards(Game.t()) :: Game.t()
  def give_cards(game = %Game{players: players, deck: deck}) do
    {players, deck} =
      players
      |> Enum.map_reduce(deck, fn {id, player}, cards ->
        {hand, deck} = Deck.draw_cards(cards, 2)
        {{id, Map.put(player, :hand, hand)}, deck}
      end)

    %{game | players: Enum.into(players, %{}), deck: deck}
    |> log("Cards distributed to the players")
  end

  @spec set_current_player(Game.t()) :: Game.t()
  def set_current_player(game = %Game{players: players, dealer: dealer}) do
    current_player = turn_start_player_id(dealer, players)

    %{game | player_turn: current_player}
    |> log("#{current_player(game).name}'s turn", broadcast: true)
  end
end
