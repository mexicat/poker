defmodule Engine.GameUtils do
  alias Engine.{Game, LogServer}

  def log(game, msg, opts \\ [])

  def log(game = %Game{log_server: nil}, msg, _) do
    %{game | log: [msg | game.log]}
  end

  def log(game = %Game{log_server: log_server}, msg, opts) do
    IO.puts(msg)
    game = %{game | log: [msg | game.log]}
    LogServer.log(log_server, msg, game, opts)
    game
  end

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

  def set_starting_player(game = %Game{dealer: dealer, players: players}) do
    next_player = small_blind_player_id(dealer, players)

    %{game | player_turn: next_player}
    |> log("#{player_id_to_name(game, next_player)}'s turn", broadcast: true)
  end

  def current_player(%Game{player_turn: player, players: players}) do
    Map.get(players, player)
  end

  def player_id_to_name(game, player_id) do
    game.players
    |> Map.get(player_id)
    |> Map.get(:name)
  end

  def player_ids_to_names(game, player_ids) do
    player_ids
    |> Enum.map(&player_id_to_name(game, &1))
  end

  def small_blind_player_id(dealer, players) do
    dealer |> next_player(players)
  end

  def big_blind_player_id(dealer, players) do
    dealer |> small_blind_player_id(players) |> next_player(players)
  end

  def turn_start_player_id(dealer, players) do
    dealer |> big_blind_player_id(players) |> next_player(players)
  end

  def remaining_players(%Game{players: players}) do
    players
    |> Enum.filter(fn {_, player} -> player.active end)
    |> Map.new()
  end

  def one_player_remaining?(game = %Game{}) do
    game
    |> remaining_players()
    |> map_size() == 1
  end

  def reset_players(game = %Game{players: players}) do
    players =
      players
      |> Enum.map(fn {k, player} ->
        {k, %{player | bet: 0, action: nil}}
      end)
      |> Enum.into(%{})

    %{game | players: players, bet: 0}
  end

  def phase_complete?(%Game{players: players, bet: bet}) do
    players
    |> Map.values()
    |> Enum.filter(& &1.active)
    |> Enum.filter(&(&1.bet != bet || &1.action == nil))
    |> Enum.empty?()
  end
end
