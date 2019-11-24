defmodule Engine do
  def via_tuple(name) do
    {:via, Registry, {Engine.GameRegistry, name}}
  end

  def new_game() do
    name =
      ?a..?z
      |> Enum.take_random(6)
      |> List.to_string()

    {:ok, _} =
      DynamicSupervisor.start_child(
        Engine.GameSupervisor,
        {Engine.GameServer, via_tuple(name)}
      )

    via_tuple(name)
  end

  def add_logger(game, pid) do
    GenServer.call(game, {:add_logger, pid})
  end

  def add_player(game, name) do
    GenServer.call(game, {:add_player, name})
  end

  def check(game, player) do
    GenServer.call(game, {:check, player})
  end

  def bet(game, player, bet) do
    GenServer.call(game, {:bet, player, bet})
  end

  def call_bet(game, player) do
    GenServer.call(game, {:call_bet, player})
  end

  def fold(game, player) do
    GenServer.call(game, {:fold, player})
  end

  def status(game) do
    GenServer.call(game, :status)
  end

  def start_game(game) do
    GenServer.call(game, :start_game)
  end
end
