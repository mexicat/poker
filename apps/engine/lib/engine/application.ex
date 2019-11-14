defmodule Engine.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Engine.GameRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: Engine.GameSupervisor}
    ]

    opts = [
      strategy: :one_for_one,
      name: Engine.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
