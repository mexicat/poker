defmodule Engine.GameServer do
  alias Engine.Game
  use GenServer

  def start_link(options) do
    {name, options} = Keyword.pop(options, :name)
    GenServer.start_link(__MODULE__, options, name: name)
  end

  def init(options \\ []) do
    {:ok, Game.new_game(options)}
  end

  def handle_call(:start_game, _from, game) do
    case Game.start_game(game) do
      {:ok, new_game} -> {:reply, :ok, new_game}
      error -> {:reply, error, game}
    end
  end

  def handle_call({:add_logger, pid}, _from, game) when is_pid(pid) do
    {:reply, :ok, %{game | log_server: pid}}
  end

  def handle_call({:add_player, name}, _from, game) do
    case Game.add_player(game, name) do
      {:ok, id, new_game} -> {:reply, {:ok, id}, new_game}
      error -> {:reply, error, game}
    end
  end

  def handle_call({:check, player}, _from, game) do
    case Game.check(game, player) do
      {:ok, new_game} -> {:reply, :ok, new_game}
      error -> {:reply, error, game}
    end
  end

  def handle_call({:bet, player, bet}, _from, game) do
    case Game.bet(game, player, bet) do
      {:ok, new_game} -> {:reply, :ok, new_game}
      error -> {:reply, error, game}
    end
  end

  def handle_call({:call_bet, player}, _from, game) do
    case Game.call_bet(game, player) do
      {:ok, new_game} -> {:reply, :ok, new_game}
      error -> {:reply, error, game}
    end
  end

  def handle_call({:fold, player}, _from, game) do
    case Game.fold(game, player) do
      {:ok, new_game} -> {:reply, :ok, new_game}
      error -> {:reply, error, game}
    end
  end

  def handle_call(:status, _from, game) do
    {:reply, game, game}
  end
end
