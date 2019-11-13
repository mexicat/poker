defmodule Engine.GameServer do
  alias Engine.Game
  use GenServer

  def start_link(name = {:via, _, _}) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def init(_) do
    {:ok, Game.new_game()}
  end

  def handle_call(:start_game, _from, game) do
    {:ok, game} = Engine.Game.start_game(game)
    {:reply, game, game}
  end

  def handle_call({:add_player, name}, _from, game) do
    {:ok, game} = Engine.Game.add_player(game, name)
    {:reply, :ok, game}
  end

  def handle_call(:status, _from, game) do
    {:reply, game, game}
  end
end
