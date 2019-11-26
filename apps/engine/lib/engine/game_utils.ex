defmodule Engine.GameUtils do
  alias Engine.{Game, LogServer, Player}

  @doc """
  Adds the `msg` line to the `log` list in the Game struct.
  If `game.log_server` is defined, this function also passes the game
  struct, and the calling options (like :broadcast and :delay), to
  `LogServer.log`, which is responsible for propagation elsewhere.
  """
  @spec log(Game.t(), String.t(), [any()]) :: Game.t()
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

  @doc """
  Given a `player` id and a list of `players`, returns the next player in order.
  """
  @spec next_player(integer, Game.players()) :: integer
  def next_player(player, players) do
    players =
      players
      |> Enum.filter(fn {_, v} -> v.active end)
      |> Enum.into(%{})
      |> Map.keys()
      |> Enum.sort()

    Enum.find(players, hd(players), &Kernel.>(&1, player))
  end

  @doc """
  Given a `player` struct, puts it into `game.players`, replacing the old one.
  The struct to replace is selected according to `game.player_turn`, so be
  careful.

  TODO: probably refactor this so instead of just player you pass {0, %Player{}}
  and the struct to replace in `players` is chosen automatically.
  """
  @spec set_player(Player.t(), Game.t()) :: Game.t()
  def set_player(player, game = %Game{players: players}) do
    players = Map.put(players, game.player_turn, player)
    %{game | players: players}
  end

  @doc """
  Sets the starting player for the phase (the small blind) on a `game`, then returns it.
  """
  @spec set_starting_player(Game.t()) :: Game.t()
  def set_starting_player(game = %Game{dealer: dealer, players: players}) do
    next_player = small_blind_player_id(dealer, players)

    %{game | player_turn: next_player}
    |> log("#{player_id_to_name(game, next_player)}'s turn", broadcast: true)
  end

  @doc """
  Given a `game`, returns the Player struct for the player currently acting.
  """
  @spec current_player(Game.t()) :: Engine.Player.t()
  def current_player(%Game{player_turn: player, players: players}) do
    Map.get(players, player)
  end

  @doc """
  Given a `game` and a `player` id, returns the player's name.
  """
  @spec player_id_to_name(Game.t(), integer) :: String.t()
  def player_id_to_name(game, player_id) do
    game.players
    |> Map.get(player_id)
    |> Map.get(:name)
  end

  @doc """
  Given a `game` and a list of `player_ids`, returns a list of names.
  """
  @spec player_ids_to_names(Game.t(), [integer, ...]) :: [String.t()]
  def player_ids_to_names(game, player_ids) do
    player_ids
    |> Enum.map(&player_id_to_name(game, &1))
  end

  @spec small_blind_player_id(integer, Game.players()) :: integer
  def small_blind_player_id(dealer, players) do
    dealer |> next_player(players)
  end

  @spec big_blind_player_id(integer, Game.players()) :: integer
  def big_blind_player_id(dealer, players) do
    dealer |> small_blind_player_id(players) |> next_player(players)
  end

  @spec turn_start_player_id(integer, Game.players()) :: integer
  def turn_start_player_id(dealer, players) do
    dealer |> big_blind_player_id(players) |> next_player(players)
  end

  @spec remaining_players(Game.t()) :: Game.players()
  def remaining_players(%Game{players: players}) do
    players
    |> Enum.filter(fn {_, player} -> player.active end)
    |> Map.new()
  end

  @spec one_player_remaining?(Game.t()) :: boolean
  def one_player_remaining?(game = %Game{}) do
    game
    |> remaining_players()
    |> map_size() == 1
  end

  @spec reset_players(Game.t()) :: Game.t()
  def reset_players(game = %Game{players: players}) do
    players =
      players
      |> Enum.map(fn {k, player} ->
        {k, %{player | bet: 0, action: nil}}
      end)
      |> Enum.into(%{})

    %{game | players: players, bet: 0}
  end

  @spec phase_complete?(Game.t()) :: boolean
  def phase_complete?(%Game{players: players, bet: bet}) do
    players
    |> Map.values()
    |> Enum.filter(& &1.active)
    |> Enum.filter(&(&1.bet != bet || &1.action == nil))
    |> Enum.empty?()
  end
end
