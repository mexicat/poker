defmodule Engine.GameServer do
  alias Engine.Game
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def init(_) do
    {:ok, deck} = Engine.Deck.start_link()
    {:ok, Game.new_game(deck)}
  end

  def handle_call(:start_game, _from, game) do
    game |> Engine.Game.start_game() |> reply(game)
  end

  def handle_call({:add_player, name}, _from, game) do
    case Engine.Game.add_player(game, name) do
      {:ok, id, new_game} -> {:reply, {:ok, id, new_game}, new_game}
      error -> {:reply, error, game}
    end
  end

  def handle_call({:check, player}, _from, game) do
    game |> Engine.Game.check(player) |> reply(game)
  end

  def handle_call({:bet, player, bet}, _from, game) do
    game |> Engine.Game.bet(player, bet) |> reply(game)
  end

  def handle_call({:call_bet, player}, _from, game) do
    game |> Engine.Game.call_bet(player) |> reply(game)
  end

  def handle_call({:fold, player}, _from, game) do
    game |> Engine.Game.fold(player) |> reply(game)
  end

  def handle_call(:status, _from, game) do
    {:reply, game, game}
  end

  defp reply({:ok, game}, _state), do: {:reply, {:ok, game}, game}
  defp reply(error, state), do: {:reply, error, state}
end
