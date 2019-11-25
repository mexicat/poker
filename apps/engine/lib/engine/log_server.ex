defmodule Engine.LogServer do
  use GenServer

  # GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    {:ok, []}
  end

  # Public API

  def log(server, action, game, opts \\ []) do
    GenServer.cast(server, {:log, action, game, opts})
  end

  def actions(server) do
    GenServer.call(server, :actions)
  end

  def process_queue(server) do
    GenServer.call(server, :process_queue)
  end

  # GenServer handles

  def handle_cast({:log, action, game, opts}, to_process) do
    {:noreply, [{action, game, opts} | to_process]}
  end

  def handle_call(:actions, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:process_queue, _from, state) do
    {:reply, state, []}
  end
end
