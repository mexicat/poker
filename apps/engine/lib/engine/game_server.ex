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
    game |> Engine.Game.start_game() |> reply(game)
  end

  def handle_call({:add_player, name}, _from, game) do
    game |> Engine.Game.add_player(name) |> reply(game)
  end

  def handle_call({:check, player}, _from, game) do
    game |> Engine.Game.check(player) |> reply(game)
  end

  def handle_call(:status, _from, game) do
    {:reply, game, game}
  end

  defp reply({:ok, game}, _state), do: {:reply, game, game}
  defp reply(error, state), do: {:reply, error, state}
end
