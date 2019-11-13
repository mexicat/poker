defmodule Engine do
  defp via_tuple(name) do
    {:via, Registry, {Engine.GameRegistry, name}}
  end

  def new_game() do
    name =
      ?a..?z
      |> Enum.take_random(6)
      |> List.to_string()

    {:ok, _} =
      DynamicSupervisor.start_child(Engine.GameSupervisor, {Engine.GameServer, via_tuple(name)})

    via_tuple(name)
  end

  def add_player(game, name) do
    GenServer.call(game, {:add_player, name})
  end

  def status(game) do
    GenServer.call(game, :status)
  end

  def start_game(game) do
    GenServer.call(game, :start_game)
  end
end
