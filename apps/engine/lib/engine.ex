defmodule Engine do
  def new_game() do
    {:ok, pid} = Supervisor.start_child(Engine.Supervisor, [])
    pid
  end

  def status(game) do
    GenServer.call(game, :status)
  end
end
