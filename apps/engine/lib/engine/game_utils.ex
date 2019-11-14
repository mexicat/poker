defmodule Engine.GameUtils do
  alias Engine.Game

  def next_player(player, players) do
    players =
      players
      |> Enum.filter(fn {_, v} -> v.active end)
      |> Enum.into(%{})
      |> Map.keys()
      |> Enum.sort()

    Enum.find(players, hd(players), &Kernel.>(&1, player))
  end

  def set_player(player, game = %Game{players: players}) do
    players = Map.put(players, game.player_turn, player)
    %{game | players: players}
  end

  def current_player(%Game{player_turn: player, players: players}) do
    Map.get(players, player)
  end

  def small_blind_player(dealer, players) do
    dealer |> next_player(players)
  end

  def big_blind_player(dealer, players) do
    dealer |> small_blind_player(players) |> next_player(players)
  end

  def turn_start_player(dealer, players) do
    dealer |> big_blind_player(players) |> next_player(players)
  end
end
