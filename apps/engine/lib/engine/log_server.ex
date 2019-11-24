defmodule Engine.LogServer do
  alias Engine.Game
  use GenServer

  def start_link(module \\ nil, fun \\ nil, game_name \\ nil) do
    GenServer.start_link(__MODULE__, {module, fun, game_name})
  end

  def init({module, fun, game_name}) do
    {:ok, {module, fun, game_name, []}}
  end

  def log(server, action, game, timeout \\ 0) do
    GenServer.cast(server, {:log, action, game})
  end

  def actions(server) do
    GenServer.call(server, :actions)
  end

  def handle_cast({:log, action, game}, state = {module, fun, game_name, actions}) do
    if module && fun && game_name, do: apply(module, fun, [game_name, game])

    {:noreply, {module, fun, game_name, [action | actions]}}
  end

  def handle_call(:actions, _from, state = {_, _, _, actions}) do
    {:reply, actions, state}
  end
end
