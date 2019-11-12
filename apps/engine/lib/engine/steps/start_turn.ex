defmodule Engine.Steps.StartTurn do
  alias Engine.Deck
  import Engine.GameUtils
  use Opus.Pipeline

  step(:move_positions)
  step(:set_blinds)
  step(:give_cards)
  step(:next, with: &Map.put(&1, :status, :pre_flop))

  def move_positions(game = %{players: players}) do
    [player | players] = players
    %{game | players: players ++ [player]}
  end

  def set_blinds(game = %{players: players, small_blind: small_blind, big_blind: big_blind}) do
    players =
      Enum.map(players |> Enum.with_index(), fn
        {player, 1} ->
          Map.put(player, :coins, player.coins - big_blind)

        {player, 2} ->
          Map.put(player, :coins, player.coins - small_blind)

        {player, _} ->
          player
      end)

    %{game | players: players, pot: big_blind + small_blind}
  end

  def give_cards(game = %{players: players, deck: deck}) do
    players =
      Enum.map(players, fn player ->
        Map.put(player, :cards, Deck.draw_cards(deck, 2))
      end)

    %{game | players: players}
  end
end
