defmodule Engine.Server do
  alias Engine.Game
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Game.new_game()}
  end

  # def handle_call({:make_move, guess}, _from, game) do
  #   {game, tally} = Game.make_move(game, guess)
  #   {:reply, tally, game}
  # end

  def handle_call(:start_game, _from, game) do
    game = Engine.Game.start_game(game)
    {:reply, game, game}
  end

  def handle_call(:status, _from, game) do
    {:reply, game, game}
  end
end
